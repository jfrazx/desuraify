module Desuraify
  class Company < Base

    def initialize(id, options={})
      super(id, options)
    end

    def url
      "http://www.desura.com/company/#{@id}"
    end
  end
end