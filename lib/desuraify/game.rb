module Desuraify

  class Game < Base
    ATTRIBUTES = [
      :boxshot, :developers, :engines, :expansion, :genres, :html, 
      :image_count, :images, :languages, :news, :news_count, :official_page, 
      :original_price, :page_title, :platforms, :players, :price, :project, 
      :publishers, :rank, :rating, :reviews, :summary, :themes, :title, 
      :updated, :video_count, :videos, :visits, :watchers
    ]

    attr_reader *ATTRIBUTES

    def initialize(id, options={})
      super(id, options)
    end

    def parse(html) 
      doc = Nokogiri::HTML(html)

      result = parse_headers(doc.css('h5'))
      result.merge!(parse_similar(doc, result[:image_count], result[:video_count]))

      # acquire prices
      prices = doc.css('.price').children.select{ |price| price unless price.text.strip.empty? }.map{ |price| price.text.strip } rescue nil

      result[:price] = prices.min unless prices.empty? rescue nil
      result[:original_price] = prices.max unless prices.empty? rescue nil

      result[:publishers] = result[:developers].map{ |dev| dev.dup } unless result[:publishers] if result[:developers]
      result[:html] = html

      result
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

    def image_rss
      "http://rss.desura.com/games/#{@id}/images/feed/rss.xml"
    end

    def video_rss
      "http://rss.desura.com/games/#{@id}/videos/feed/rss.xml"
    end

  end # end of class
end