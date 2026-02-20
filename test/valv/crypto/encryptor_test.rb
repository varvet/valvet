# frozen_string_literal: true

require "test_helper"

class EncryptorTest < Minitest::Test
  include TestFixtures

  def test_to_s_returns_base64_public_key
    encryptor = Valv::Crypto::Encryptor.new(PUBLIC_KEY)
    assert_equal PUBLIC_KEY, encryptor.to_s
  end

  def test_encrypt_returns_base64_ciphertext
    encryptor = Valv::Crypto::Encryptor.new(PUBLIC_KEY)
    ciphertext = encryptor.encrypt("hello")
    assert_kind_of String, ciphertext
    refute_empty ciphertext
    refute_equal "hello", ciphertext
  end

  def test_encrypt_produces_different_ciphertext_each_time
    encryptor = Valv::Crypto::Encryptor.new(PUBLIC_KEY)
    c1 = encryptor.encrypt("hello")
    c2 = encryptor.encrypt("hello")
    refute_equal c1, c2
  end
end
