# frozen_string_literal: true

require "test_helper"

class TestEncrypted < Minitest::Test
  def test_stores_ciphertext
    encrypted = Valvet::Encrypted.new(ciphertext: "abc123")
    assert_equal "abc123", encrypted.ciphertext
  end

  def test_empty_when_ciphertext_is_empty
    assert Valvet::Encrypted.new(ciphertext: "").empty?
  end

  def test_not_empty_when_ciphertext_present
    refute Valvet::Encrypted.new(ciphertext: "abc").empty?
  end
end
