# frozen_string_literal: true

require "test_helper"

class YAMLTest < Minitest::Test
  include TestFixtures

  def setup
    Valvet::YAML.register
  end

  def test_encrypted_round_trip
    encrypted = Valvet::Encrypted.new(ciphertext: "abc123")
    yaml = ::YAML.dump(encrypted)
    assert_includes yaml, "!encrypted"
    loaded = ::YAML.unsafe_load(yaml)
    assert_kind_of Valvet::Encrypted, loaded
    assert_equal "abc123", loaded.ciphertext
  end

  def test_public_key_round_trip
    public_key = Valvet::PublicKey.new(key: PUBLIC_KEY)
    yaml = ::YAML.dump(public_key)
    assert_includes yaml, "!public_key"
    loaded = ::YAML.unsafe_load(yaml)
    assert_kind_of Valvet::PublicKey, loaded
    assert_equal PUBLIC_KEY, loaded.key
  end

  def test_store_to_yaml
    hash = {
      "public_key" => Valvet::PublicKey.new(key: PUBLIC_KEY),
      "api_key" => Valvet::Encrypted.new(ciphertext: "O6wBE5yFRSndxa9u5+ITXtgQY+8XscfcoNCMIZ+Ch3KTNbyyoJaNJ4amVwu6cfRXasmOyRqm"),
      "timeout" => 30
    }
    store = Valvet.new(hash, private_keys: [PRIVATE_KEY])
    yaml = store.to_yaml
    loaded = ::YAML.unsafe_load(yaml)
    assert_kind_of Valvet::PublicKey, loaded["public_key"]
    assert_kind_of Valvet::Encrypted, loaded["api_key"]
    assert_equal 30, loaded["timeout"]
  end
end
