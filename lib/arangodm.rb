require 'pp'
require 'rest-client'
require 'json'
require "arangodm/load"

module Arangodm

  class << self
    attr_accessor :host
  end

  @host = 'http://127.0.0.1:8529'

end
