# frozen_string_literal: true

require "test_helper"

class DecryptorTest < Minitest::Test
  include TestFixtures

  def test_to_s_returns_base64_private_key
    decryptor = Valvet::Crypto::Decryptor.new(PRIVATE_KEY)
    assert_equal PRIVATE_KEY, decryptor.to_s
  end

  def test_public_key_is_deterministic
    d1 = Valvet::Crypto::Decryptor.new(PRIVATE_KEY)
    d2 = Valvet::Crypto::Decryptor.new(PRIVATE_KEY)
    assert_equal d1.public_key, d2.public_key
  end

  def test_public_key_matches_known_value
    decryptor = Valvet::Crypto::Decryptor.new(PRIVATE_KEY)
    assert_equal PUBLIC_KEY, decryptor.public_key
  end

  def test_encryptor_returns_matching_encryptor
    decryptor = Valvet::Crypto::Decryptor.new(PRIVATE_KEY)
    encryptor = decryptor.encryptor
    assert_kind_of Valvet::Crypto::Encryptor, encryptor
    assert_equal PUBLIC_KEY, encryptor.to_s
  end

  def test_decrypt_round_trip
    decryptor = Valvet::Crypto::Decryptor.new(PRIVATE_KEY)
    ciphertext = decryptor.encryptor.encrypt("hello")
    assert_equal "hello", decryptor.decrypt(ciphertext)
  end

  def test_decrypt_with_wrong_key_raises
    encryptor = Valvet::Crypto::Encryptor.new(PUBLIC_KEY)
    ciphertext = encryptor.encrypt("hello")

    wrong_decryptor = Valvet::Crypto::Decryptor.new(OTHER_PRIVATE_KEY)
    assert_raises(RbNaCl::CryptoError) { wrong_decryptor.decrypt(ciphertext) }
  end

  def test_decrypt_empty_string
    decryptor = Valvet::Crypto::Decryptor.new(PRIVATE_KEY)
    ciphertext = decryptor.encryptor.encrypt("")
    assert_equal "", decryptor.decrypt(ciphertext)
  end

  def test_decrypt_unicode
    decryptor = Valvet::Crypto::Decryptor.new(PRIVATE_KEY)
    plaintext = "héllo wörld 🔑"
    ciphertext = decryptor.encryptor.encrypt(plaintext)
    assert_equal plaintext.b, decryptor.decrypt(ciphertext)
  end
end
