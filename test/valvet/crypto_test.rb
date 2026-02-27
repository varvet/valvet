# frozen_string_literal: true

require "test_helper"

class CryptoTest < Minitest::Test
  def test_generate_returns_decryptor
    assert_kind_of Valvet::Crypto::Decryptor, Valvet::Crypto.generate
  end

  def test_encode_decode_round_trip
    data = "hello"
    encoded = Valvet::Crypto.encode(data)
    assert_equal data, Valvet::Crypto.decode(encoded)
  end

  def test_encode_returns_base64
    encoded = Valvet::Crypto.encode("hello")
    assert_match(/\A[A-Za-z0-9+\/]*=*\z/, encoded)
  end
end
