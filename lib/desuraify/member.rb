module Desuraify
  class Member < Base

    ATTRIBUTES = [
      :activity_points, :comments, :country, :gender, :html, :images, :images_count, 
      :level, :offline, :rank, :site_visits, :time_online, :videos, :videos_count, 
      :visits, :watchers
    ]

    attr_reader *ATTRIBUTES

    def initialize(id, options={})
      super(id, options)
    end

    def parse(html)
      doc = Nokogiri::HTML(html)

      result = parse_headers(doc.css('h5'))
      result.merge!(parse_similar(doc, result[:image_count], result[:video_count]))
      result[:html] = html

      result
    end

    def attributes
      ATTRIBUTES
    end

    def url
      "http://www.desura.com/members/#{@id}"
    end

    def image_rss
      "http://rss.desura.com/members/#{@id}/images/feed/rss.xml"
    end

    def video_rss
      "http://rss.desura.com/members/#{@id}/videos/feed/rss.xml"
    end
  end
end
