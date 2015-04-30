require 'active_support/core_ext'
require 'konf'

pub_config = (YAML.load(ERB.new(File.read(File.expand_path('../config.yml', File.dirname(__FILE__)))).result)[Rails.env] rescue {}) || {}
AppConfig = Konf.new(pub_config)