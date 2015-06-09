module Desuraify

  class Game < Base
    ATTRIBUTES = [
      :boxshot, :developers, :engines, :expansion, :genres, :html, 
      :image_count, :images, :languages, :news, :official_page, :original_price, 
      :page_title, :platforms, :players, :price, :project, :publishers, :rank, 
      :rating, :reviews, :summary, :themes, :title, :updated, :video_count, :videos, 
      :visits, :watchers
    ]

    attr_reader *ATTRIBUTES

    def initialize(id, options={})
      super(id, options)
    end

    def parse(html, options={})
      result = Hash.new
      
      doc = Nokogiri::HTML(html)

      headers = doc.css('h5')

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

          result[:project] = header.parent.children.select do |theme|
            theme unless theme == header || theme.text.strip.empty?
          end.map {|theme| theme.text.strip }.uniq

        when "Players"

          result[:players] = header.parent.children.select do |player|
            player unless player == header || player.text.strip.empty?
          end.map{|player| player.text.strip }.uniq

        when "Boxshot"

          result[:boxshot] = header.parent.search('a').attribute('href').value.strip rescue nil

        when "Last Update"

          result[:updated] = header.next.next.text.strip rescue nil

        when "Watchers"

          result[:watchers] = header.next.next.text.strip rescue nil

        when "Images"

          result[:image_count] = header.next.next.text.strip.to_i rescue nil

        when "Rank"

          result[:rank] = header.next.next.text.strip rescue nil

        when "Videos"

          result[:video_count] = header.next.next.text.strip rescue nil

        when "Visits"

          result[:visits] = header.next.next.text.strip rescue nil

        when "Official Page"

          result[:official_page] = header.parent.search('a').attribute('href').value.strip rescue nil

        end # end of case statement

      end # end of header loop


      # acquire prices
      prices = doc.css('.price').children.select{ |price| price unless price.text.strip.empty? }.map{ |price| price.text.strip } rescue nil

      result[:price] = prices.min unless prices.empty? rescue nil
      result[:original_price] = prices.max unless prices.empty? rescue nil
      result[:rating] = doc.at_css('.score').text.strip rescue nil

      result[:videos] = doc.css('.videobox').search('a').map do |video|
        values = video.attribute('href').value.strip.split('/')
        values.pop
        "http://www.desura.com#{values.join('/')}"
      end rescue nil

      result[:images] = doc.css('.mediaitem').search('a').select{|item| item if item.attribute('href').value.match(/^https?/i) }.map{|pic| pic.attribute('href').value.strip }
      result[:summary] = doc.at_css('.body.clear').search('p').map{ |paragraph| paragraph.text.strip }
      result[:publishers] = result[:developers].map{ |dev| dev.dup } unless result[:publishers] if result[:developers]
      result[:page_title] = doc.css('title').text.strip
      result[:title] = doc.at_css('.title').css('h2').text.strip rescue nil
      result[:html] = html

      if(result[:image_count] && result[:images].size < result[:image_count])
        images = rss_update
        images.each { |image| result[:images] << image unless result[:images].include?(image) }.compact if images rescue nil
      end

      result
    end

    def parse_rss(body)
      xml = Nokogiri::XML(body)
      xml.search('enclosure').map{|image| image.attribute('url').value.strip } 
    end

    def url
      "http://www.desura.com/games/#{@id}"
    end

    def attributes
      ATTRIBUTES
    end

    def to_s
      "#{@title} for #{@platforms.join(', ')}" rescue "#{self.class}::#{self.object_id}"
    end

    private

    def rss
      "http://rss.desura.com/games/#{@id}/images/feed/rss.xml"
    end

  end # end of class
end