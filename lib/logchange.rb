require 'logchange/version'
require 'logchange/configuration'
require 'logchange/dispatch'
require 'logchange/initialize'
require 'logchange/logger'

module Logchange
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Logchange::Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
