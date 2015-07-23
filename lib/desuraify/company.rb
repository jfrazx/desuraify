module Desuraify
  class Company < Base

    ATTRIBUTES = [
      :address, :company, :engines_count, :games_count, :html, :images, :images_count,
      :members, :members_count, :news_count, :office, :official_page, :phone, :rank, 
      :videos, :videos_count, :visits, :watchers
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