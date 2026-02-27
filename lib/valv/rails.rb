# frozen_string_literal: true

require "valv"
require "rails"

module Valv
  class Railtie < ::Rails::Railtie
    config.valv = ActiveSupport::OrderedOptions.new
    config.valv.private_keys = [ENV["VALV_PRIVATE_KEY"]].compact

    initializer "valv.register_yaml_tags", before: :load_environment_config do
      Valv::YAML.register
    end

    initializer "valv.configure" do |app|
      valv_path = app.root.join("config", "valv.yml")

      if valv_path.exist?
        hash = app.config_for(:valv).to_h.deep_stringify_keys
        app.config.valv = Valv.new(hash, private_keys: app.config.valv.private_keys)
      end
    end
  end
end
