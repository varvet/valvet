# frozen_string_literal: true

require "test_helper"

class ValvTest < Minitest::Test
  include TestFixtures

  def test_that_it_has_a_version_number
    refute_nil ::Valv::VERSION
  end

  def test_decrypts_with_matching_private_key
    hash = {
      "public_key" => Valv::PublicKey.new(key: PUBLIC_KEY),
      "api_key" => Valv::Encrypted.new(ciphertext: "O6wBE5yFRSndxa9u5+ITXtgQY+8XscfcoNCMIZ+Ch3KTNbyyoJaNJ4amVwu6cfRXasmOyRqm")
    }
    store = Valv.new(hash, private_keys: [PRIVATE_KEY])
    assert_equal "secret", store.api_key
  end

  def test_encrypts_when_assigning
    hash = {
      "public_key" => Valv::PublicKey.new(key: PUBLIC_KEY),
      "api_key" => Valv::Encrypted.new(ciphertext: "O6wBE5yFRSndxa9u5+ITXtgQY+8XscfcoNCMIZ+Ch3KTNbyyoJaNJ4amVwu6cfRXasmOyRqm")
    }
    original_ciphertext = hash["api_key"].ciphertext
    store = Valv.new(hash, private_keys: [PRIVATE_KEY])
    store.api_key = "new_secret"
    refute_equal original_ciphertext, hash["api_key"].ciphertext
    assert_equal "new_secret", store.api_key
  end

  def test_raises_without_matching_private_key
    hash = {
      "public_key" => Valv::PublicKey.new(key: OTHER_PUBLIC_KEY),
      "api_key" => Valv::Encrypted.new(ciphertext: "z+FYZjebo0i+kqJQw/NbomfFaup1srXqTySBWCf67Qy63NjVBSxpj+AH4kjHaz7iuzn8VJgW")
    }
    store = Valv.new(hash, private_keys: [PRIVATE_KEY])
    assert_raises(Valv::Error::NoDecryptorError) { store.api_key }
  end
end
