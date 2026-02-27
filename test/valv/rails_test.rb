# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"
require "test_helper"
require_relative "../dummy/config/environment"

class Valv::RailsTest < Minitest::Test
  def test_decrypts_values_from_valv_yml
    assert_equal "dummy-secret", Rails.configuration.valv.secret_key_base
  end
end
