module Desuraify
  class Engine < Base
    ATTRIBUTES = [
      :developers, :games, :game_count, :images, :image_count, :license, :news, 
      :news_count, :official_page, :page_title, :platforms, :publishers, :rank, 
      :rating, :release_date, :reviews, :summary, :title, :updated, :videos, 
      :video_count, :visits, :watchers
    ]

    attr_reader *ATTRIBUTES

    def initialize(id, options={})
      super(id, options)
    end

    def parse(html)

      doc = Nokogiri::HTML(html)

      result = parse_headers(doc.css('h5'))
      result.merge!(parse_similar(doc, result[:image_count], result[:video_count]))

      result

    end

    def url
      "http://www.desura.com/engines/#{@id}"
    end

    def attributes
      ATTRIBUTES
    end

    private

    def image_rss
      "http://rss.desura.com/engines/#{@id}/images/feed/rss.xml"
    end

    def video_rss
      "http://rss.desura.com/engines/#{@id}/videos/feed/rss.xml"
    end
  end
end