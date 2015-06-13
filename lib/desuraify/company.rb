module Desuraify
  class Company < Base

    ATTRIBUTES = [
      :members, :member_count, :html, :official_page, :company, :rank, :visits, :game_count, 
      :office, :watchers, :address, :phone, :engine_count, :news_count, :images, 
      :image_count, :videos, :video_count
    ]

    attr_reader *ATTRIBUTES

    def initialize(id, options={})
      super(id, options)
    end

    def parse(html)

      doc = Nokogiri::HTML(html)

      result = parse_headers(doc.css('h5'))
      result.merge!(parse_similar(doc))
      result[:html] = html

      result
    end

    def url
      "http://www.desura.com/company/#{@id}"
    end

    def image_rss
      "http://rss.desura.com/company/#{@id}/images/feed/rss.xml"
    end

    def video_rss
      "http://rss.desura.com/company/#{@id}/videos/feed/rss.xml"
    end

    def attributes
      ATTRIBUTES
    end
  end
end