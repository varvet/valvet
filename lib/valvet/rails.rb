# frozen_string_literal: true

require "valvet"
require "rails"

module Valvet
  class Railtie < ::Rails::Railtie
    config.valvet = ActiveSupport::OrderedOptions.new
    config.valvet.private_keys = [ENV["VALVET_PRIVATE_KEY"]].compact

    initializer "valvet.register_yaml_tags", before: :load_environment_config do
      Valvet::YAML.register
    end

    initializer "valvet.configure" do |app|
      valvet_path = app.root.join("config", "valvet.yml")

      if valvet_path.exist?
        hash = app.config_for(:valvet).to_h.deep_stringify_keys
        app.config.valvet = Valvet.new(hash, private_keys: app.config.valvet.private_keys)
      end
    end
  end
end
