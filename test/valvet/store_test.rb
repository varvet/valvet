# frozen_string_literal: true

require "test_helper"

class StoreTest < Minitest::Test
  include TestFixtures

  def setup
    @decryptor = Valvet::Crypto::Decryptor.new(PRIVATE_KEY)
    @encryptor = @decryptor.encryptor
    @public_key = Valvet::PublicKey.new(key: PUBLIC_KEY)
  end

  def new_store(hash, &handler)
    handler ||= method(:handle)
    Valvet::Store.new(hash, &handler)
  end

  def handle(intent)
    case intent
    when Valvet::Store::Decrypt then @decryptor.decrypt(intent.ciphertext)
    when Valvet::Store::Encrypt then @encryptor.encrypt(intent.plaintext)
    end
  end

  def test_resolves_plain_values
    store = new_store({"timeout" => 30})
    assert_equal 30, store.timeout
  end

  def test_decrypts_encrypted_values
    hash = {
      "public_key" => @public_key,
      "api_key" => Valvet::Encrypted.new(ciphertext: "O6wBE5yFRSndxa9u5+ITXtgQY+8XscfcoNCMIZ+Ch3KTNbyyoJaNJ4amVwu6cfRXasmOyRqm")
    }
    store = new_store(hash)
    assert_equal "secret", store.api_key
  end

  def test_resolves_nested_hash_to_store
    hash = {"service" => {"timeout" => 5}}
    store = new_store(hash)
    assert_kind_of Valvet::Store, store.service
    assert_equal 5, store.service.timeout
  end

  def test_key?
    store = new_store({"timeout" => 30})
    assert store.key?("timeout")
    refute store.key?("missing")
  end

  def test_to_h_excludes_public_keys
    hash = {
      "public_key" => @public_key,
      "api_key" => Valvet::Encrypted.new(ciphertext: "O6wBE5yFRSndxa9u5+ITXtgQY+8XscfcoNCMIZ+Ch3KTNbyyoJaNJ4amVwu6cfRXasmOyRqm"),
      "timeout" => 30
    }
    store = new_store(hash)
    result = store.to_h
    refute result.key?("public_key")
    assert_equal "secret", result["api_key"]
    assert_equal 30, result["timeout"]
  end

  def test_assign_encrypts_when_replacing_encrypted_value
    hash = {
      "public_key" => @public_key,
      "api_key" => Valvet::Encrypted.new(ciphertext: "G+psgOQQ5Kq+NxQ15nTfAXIEOexzpa2RYUV69XLn+jtz+8XDN6t5xL1nLsvz/hTtkEUo")
    }
    store = new_store(hash)
    store.api_key = "new_value"
    assert_kind_of Valvet::Encrypted, hash["api_key"]
    assert_equal "new_value", store.api_key
  end

  def test_assign_plain_value
    hash = {"timeout" => 30}
    store = new_store(hash)
    store.timeout = 60
    assert_equal 60, store.timeout
  end

  def test_raises_without_handler
    hash = {
      "public_key" => @public_key,
      "api_key" => Valvet::Encrypted.new(ciphertext: "O6wBE5yFRSndxa9u5+ITXtgQY+8XscfcoNCMIZ+Ch3KTNbyyoJaNJ4amVwu6cfRXasmOyRqm")
    }
    store = Valvet::Store.new(hash)
    assert_raises { store.api_key }
  end

  def test_each_skips_public_key_entries
    hash = {
      "public_key" => @public_key,
      "api_key" => Valvet::Encrypted.new(ciphertext: "O6wBE5yFRSndxa9u5+ITXtgQY+8XscfcoNCMIZ+Ch3KTNbyyoJaNJ4amVwu6cfRXasmOyRqm"),
      "timeout" => 30
    }
    store = new_store(hash)
    paths = []
    store.each { |path, _value, _store| paths << path }
    refute_includes paths, ["public_key"]
    assert_includes paths, ["api_key"]
    assert_includes paths, ["timeout"]
  end

  def test_each_recurses_into_nested_hashes
    hash = {"service" => {"timeout" => 5, "retries" => 3}}
    store = new_store(hash)
    paths = []
    store.each { |path, _value, _store| paths << path }
    assert_includes paths, ["service", "timeout"]
    assert_includes paths, ["service", "retries"]
  end

  def test_respond_to_missing
    store = new_store({"timeout" => 30})
    assert store.respond_to?(:timeout)
    assert store.respond_to?(:timeout=)
    refute store.respond_to?(:unknown)
  end

  def test_raises_for_unknown_keys
    store = new_store({"timeout" => 30})
    assert_raises(NoMethodError) { store.unknown }
  end
end
