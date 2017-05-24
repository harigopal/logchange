require_relative 'logchange/version'
require_relative 'logchange/configuration'
require_relative 'logchange/dispatch'
require_relative 'logchange/initialize'
require_relative 'logchange/logger'
require_relative 'logchange/interactive_logger'
require_relative 'logchange/release'

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
