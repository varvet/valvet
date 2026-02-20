# frozen_string_literal: true

require "test_helper"

class CryptoTest < Minitest::Test
  def test_generate_returns_decryptor
    assert_kind_of Valv::Crypto::Decryptor, Valv::Crypto.generate
  end

  def test_encode_decode_round_trip
    data = "hello"
    encoded = Valv::Crypto.encode(data)
    assert_equal data, Valv::Crypto.decode(encoded)
  end

  def test_encode_returns_base64
    encoded = Valv::Crypto.encode("hello")
    assert_match(/\A[A-Za-z0-9+\/]*=*\z/, encoded)
  end
end
