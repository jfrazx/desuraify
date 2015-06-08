require "uri"
require "nokogiri"
require "typhoeus"

# Dir.glob(File.join('path', '**', '*.rb'), &method(:require))
require "desuraify/exception"
require "desuraify/base"
require "desuraify/game"
require "desuraify/engine"
require "desuraify/member"
require "desuraify/company"
require "desuraify/version"

module Desuraify
  def self.hydra
    @hydra ||= Typhoeus::Hydra.new(:max_concurrency => 5)
  end
end
