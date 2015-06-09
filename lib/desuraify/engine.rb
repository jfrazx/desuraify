module Desuraify
  class Engine < Base
    ATTRIBUTES = [
      :developer, :games, :images, :license, :news, :official_page, 
      :page_title, :platforms, :publishers, :rank, :rating, :release_date, 
      :reviews, :summary, :title, :updated, :videos, :visits, :watchers
    ]

    attr_reader *ATTRIBUTES

    def initialize(id, options={})
      super(id, options)
    end

    def url
      "http://www.desura.com/engines/#{@id}"
    end
  end
end