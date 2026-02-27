# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"
require "test_helper"
require_relative "../dummy/config/environment"

class Valvet::RailsTest < Minitest::Test
  def test_decrypts_values_from_valvet_yml
    assert_equal "dummy-secret", Rails.configuration.valvet.secret_key_base
  end
end
