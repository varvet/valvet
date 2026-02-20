# frozen_string_literal: true

require "test_helper"

class TestEncrypted < Minitest::Test
  def test_stores_ciphertext
    encrypted = Valv::Encrypted.new(ciphertext: "abc123")
    assert_equal "abc123", encrypted.ciphertext
  end

  def test_empty_when_ciphertext_is_empty
    assert Valv::Encrypted.new(ciphertext: "").empty?
  end

  def test_not_empty_when_ciphertext_present
    refute Valv::Encrypted.new(ciphertext: "abc").empty?
  end
end
