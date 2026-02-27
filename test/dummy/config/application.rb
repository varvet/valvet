require_relative "boot"

require "rails"
require "valvet/rails"

module Dummy
  class Application < Rails::Application
    config.root = File.expand_path("..", __dir__)
    config.load_defaults Rails::VERSION::STRING.to_f
    config.eager_load = false
    config.valvet.private_keys = ["LupoKAFUrJGJGSxOQEH9jSNx4N29oEfkbRiWXsn15QE="]
  end
end
