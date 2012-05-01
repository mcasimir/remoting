require 'yaml'
require 'ostruct'

module Remote
  class Config < OpenStruct

    def initialize
      hash = YAML.load_file(Rails.root('config', 'remote.yml'))
      super(hash["remote"])
    end

  end
  
  def config
    @config ||= Config.new
  end
  module_function :config
end