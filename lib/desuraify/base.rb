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

        attribute = header.text.strip.split(" ").join("_").downcase.intern

        case header.text.strip
        when /^Platforms?$/i

          result[:platforms] = header.parent.children.search('a').select do |platform|
            platform unless platform == header || platform.text.strip.empty?
          end.map! {|platform| platform.text.strip }.uniq

        when /^Engine$/i

          result[:engines] = header.parent.children.select do |engine|
            engine unless engine == header || engine.text.strip.empty?
          end.map do |engine|
            eng = Hash.new
            eng[:name] = engine.text.strip
            eng[:id] = engine.child.attribute('href').value.split('/').last rescue nil
            eng
          end.uniq

        when /^Developers?/i, /Publishers?$/i

          attribute = header.text.downcase
          attribute << "s" unless attribute[-1] == "s"

          result[attribute.intern] = header.parent.children.select do |entity|
            entity unless entity == header || entity.text.strip.empty?
          end.map do |entity|
            target = Hash.new
            target[:name] = entity.text.strip
            href = entity.child.attribute('href').value.split('/')
            target[:company] = !!href.find{|company| company.match(/^company$/i)}
            target[:id] = href.last
            target
          end.uniq

        when /Languages?/i, /^Genres?/i, /^Themes?$/i, "Players", /^Projects?$/

          attribute = header.text.downcase
          attribute << "s" unless attribute[-1] == "s"

          result[attribute.intern] = header.parent.children.select do |entity|
            entity unless entity == header || entity.text.strip.empty?
          end.map! {|entity| entity.text.strip }.uniq

        when /^This game is an expansion for\s+?/i

          match = header.text.strip.match(/^This game is an expansion for\s+?(.*)/i)
          expansion = Hash.new
          expansion[:title] = match[match.size-1]
          expansion[:boxshot] = header.parent.search('img').attribute('src').value.strip
          expansion[:id] = header.parent.search('a').attribute('href').value.split('/').last.strip
          result[:expansion] = expansion

        when "Boxshot"

          result[attribute] = header.parent.search('a').attribute('href').value.strip rescue nil

        when "Last Update"

          result[:updated] = header.next.next.text.strip rescue nil

        when "News", "Members", "Videos", "Games", "Images", "Engines"

          attribute = header.text.strip.split(" ").push("count").join("_").downcase.intern
          result[attribute] = header.next.next.text.strip.to_i rescue nil


        when "Visits", "Profile Visitors"

          result[:visits] = header.next.next.text.strip rescue nil

        when "Official Page", "Homepage"

          result[:official_page] = header.parent.search('a').attribute('href').value.strip rescue nil

        when "Offline Since"

          result[:offline] = header.next.next.text.strip rescue nil

        when "Activity Points"

          result[:activity_points] = header.next.next.text.strip.to_i rescue nil

        when "Company", "Office", "Time Online", "Site Visits", /^Gender/, /^Country/, "Established", "Watchers", "Rank", "License", "Release Date", "Phone"

          result[attribute] = header.next.next.text.strip rescue nil

        when "Address"

          addresses = Array.new

          header.parent.children.each do |child|
            next if child == header || child.text.strip.empty?
            break if child.text.strip == "Phone"
            addresses << child.text.strip
          end

          result[:address] = addresses.map { |address| address.split("\n") }.flatten

        end

      end

      result[:engines_count]  = result[:engines_count]  || 0
      result[:images_count]   = result[:images_count]   || 0
      result[:videos_count]   = result[:videos_count]   || 0 
      result[:games_count]    = result[:games_count]    || 0 
      result[:news_count]     = result[:news_count]     || 0 

      result
    end

    def parse_similar(doc, img_count=0, vid_count=0)
      result = Hash.new

      result[:rating] = doc.at_css('.score').text.strip.to_f rescue nil
      result[:level]  = result[:rating]

      result[:videos] = doc.css('.videobox').search('a').map do |video|
        values = video.attribute('href').value.strip.split('/')
        values.pop
        "http://www.desura.com#{values.join('/')}"
      end rescue nil

      result[:videos] = rss_update(video_rss) if result[:videos].size < vid_count rescue nil

      result[:images] = doc.css('.mediaitem').search('a').select{|item| item if item.attribute('href').value.match(/^https?/i) }.map{|pic| pic.attribute('href').value.strip }
      result[:images] = rss_update(image_rss) if result[:images].size < img_count rescue nil

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
