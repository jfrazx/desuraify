module Desuraify
  # base class to inherit, hopefully reducing duplicate code

  class Base

    attr_reader :id
    attr_reader :hydra
    attr_reader :callback
    attr_reader :error

    def initialize(id, options={})
      @id = id
      @hydra = options[:hydra] || Desuraify.hydra
      @request_opts = options[:request_opts] || {}
      @callback = nil
      @error = nil
    end

    def update
      resp = Typhoeus::Request.get(url, @request_opts)
      result = handle_response(resp)
      update_callback(result)

      self
    end

    def enqueue_update(&block)
      @callback = block
      @error = nil

      request = Typhoeus::Request.new(url, @request_opts)

      request.on_complete do |response|
        result = nil

        begin
          result = handle_response(response)
        rescue Exception => e
          @error = e
        end

        update_callback(result)
      end

      hydra.queue(request)

      self
    end

    def parse_headers(headers)
      result = Hash.new

      headers.each do |header|
        next if header.text.strip.empty?

        case header.text.strip
        when /^Platforms?$/i

          result[:platforms] = header.parent.children.search('a').select do |platform|
            platform unless platform == header || platform.text.strip.empty?
          end.map! {|platform| platform.text.strip }.uniq

        when /^Engines?$/i

          result[:engines] = header.parent.children.select do |engine|
            engine unless engine == header || engine.text.strip.empty?
          end.map do |engine|
            eng = Hash.new
            eng[:name] = engine.text.strip
            eng[:id] = engine.child.attribute('href').value.split('/').last rescue nil
            eng
          end.uniq

        when /^Developers?/i

          result[:developers] = header.parent.children.select do |developer|
            developer unless developer == header || developer.text.strip.empty?
          end.map do |develop|
            developer = Hash.new
            developer[:name] = develop.text.strip
            href = develop.child.attribute('href').value.split('/')
            developer[:company] = !!href.find{|company| company.match(/^company$/i)}
            developer[:id] = href.last
            developer
          end.uniq

        when /Publishers?$/i

          result[:publishers] = header.parent.children.select do |publisher|
            publisher unless publisher == header || publisher.text.strip.empty?
          end.map do |pub|
            publisher = Hash.new
            publisher[:name] = pub.text.strip
            href = pub.child.attribute('href').value.split('/')
            publisher[:company] = !!href.find{|company| company.match(/^company$/i)}
            publisher[:id] = href.last
            publisher
          end.uniq

        when /Languages?/i

          result[:languages] = header.parent.children.select do |language|
            language unless language == header || language.text.strip.empty?
          end.map! {|language| language.text.strip }.uniq

        when /^Genres?/i

          result[:genres] = header.parent.children.select do |genre|
            genre unless genre == header || genre.text.strip.empty?
          end.map {|genre| genre.text.strip }.uniq

        when /^Themes?$/i

          result[:themes] = header.parent.children.select do |theme|
            theme unless theme == header || theme.text.strip.empty?
          end.map {|theme| theme.text.strip }.uniq

        when /^This game is an expansion for\s+?/i

          match = header.text.strip.match(/^This game is an expansion for\s+?(.*)/i)
          expansion = Hash.new
          expansion[:title] = match[match.size-1]
          expansion[:boxshot] = header.parent.search('img').attribute('src').value.strip
          expansion[:id] = header.parent.search('a').attribute('href').value.split('/').last.strip
          result[:expansion] = expansion

        when /^Projects?$/

          result[:project] = header.parent.children.select do |project|
            project unless project == header || project.text.strip.empty?
          end.map {|project| project.text.strip }.uniq

        when "Players"

          result[:players] = header.parent.children.select do |player|
            player unless player == header || player.text.strip.empty?
          end.map{|player| player.text.strip }.uniq

        when "Boxshot"

          result[:boxshot] = header.parent.search('a').attribute('href').value.strip rescue nil

        when "Last Update"

          result[:updated] = header.next.next.text.strip rescue nil

        when "License"

          result[:license] = header.next.next.text.strip rescue nil

        when "Release Date"

          result[:release_date] = header.next.next.text.strip rescue nil

        when "Watchers"

          result[:watchers] = header.next.next.text.strip rescue nil

        when "Images"

          result[:image_count] = header.next.next.text.strip.to_i rescue nil

        when "Games"

          result[:game_count] = header.next.next.text.strip.to_i   rescue nil

        when "News"

          result[:news_count] = header.next.next.text.strip.to_i rescue nil

        when "Rank"

          result[:rank] = header.next.next.text.strip rescue nil

        when "Videos"

          result[:video_count] = header.next.next.text.strip.to_i rescue nil

        when "Visits"

          result[:visits] = header.next.next.text.strip rescue nil

        when "Official Page"

          result[:official_page] = header.parent.search('a').attribute('href').value.strip rescue nil

        end
      end

      result
    end

    def parse_similar(doc, img_count=0, vid_count=0)
      result = Hash.new

      result[:rating] = doc.at_css('.score').text.strip rescue nil

      result[:videos] = doc.css('.videobox').search('a').map do |video|
        values = video.attribute('href').value.strip.split('/')
        values.pop
        "http://www.desura.com#{values.join('/')}"
      end rescue nil
      result[:videos] = rss_update(video_rss) if result[:videos].size < vid_count

      result[:images] = doc.css('.mediaitem').search('a').select{|item| item if item.attribute('href').value.match(/^https?/i) }.map{|pic| pic.attribute('href').value.strip }
      result[:images] = rss_update(image_rss) if result[:images].size < img_count

      result[:summary] = doc.at_css('.body.clear').search('p').map{ |paragraph| paragraph.text.strip }
      result[:page_title] = doc.css('title').text.strip
      result[:title] = doc.at_css('.title').css('h2').text.strip rescue nil

      result
    end

    def to_s
      "#{@title}" rescue "#{self.class}::#{self.object_id}"
    end

    def rss_update(url)
      response = Typhoeus::Request.get(url, @request_opts)
      if response.success?
        xml = Nokogiri::XML(response.body)
        data = xml.search('enclosure').map{|item| item.attribute('url').value.strip }

        block_given? ? (yield data) : data
      end
    end

    private

    def handle_response(response)
      if response.success?
        parse(response.body)
      else
        raise Desuraify::ResponseError.new("Got unexpected response code: #{response.code}")
      end
    end

    def update_callback(result)
      unless @error
        self.attributes.each do |a|
          attr_name = "@#{a}"
          attr_value = result[a]
          instance_variable_set(attr_name, attr_value)
        end
      end

      @callback.call(self) if @callback
    end

  end
end