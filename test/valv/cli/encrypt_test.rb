# frozen_string_literal: true

require "test_helper"
require "valv/cli"

class Valv::CLI::EncryptTest < Minitest::Test
  include CLIHelper
  include TestFixtures

  def test_outputs_ciphertext
    result = cli(["encrypt", "hello", "--key", PUBLIC_KEY])
    assert_equal 0, result.status
    ciphertext = result.out.strip
    refute_empty ciphertext
    plaintext = Valv::Crypto::Decryptor.new(PRIVATE_KEY).decrypt(ciphertext)
    assert_equal "hello", plaintext
  end

  def test_short_flag
    result = cli(["e", "hello", "-k", PUBLIC_KEY])
    assert_equal 0, result.status
    ciphertext = result.out.strip
    plaintext = Valv::Crypto::Decryptor.new(PRIVATE_KEY).decrypt(ciphertext)
    assert_equal "hello", plaintext
  end

  def test_missing_key_returns_1
    result = cli(%w[encrypt hello])
    assert_equal 1, result.status
    assert_empty result.out
    assert_match(/--key/, result.err)
  end

  def test_missing_value_returns_1
    result = cli(["encrypt", "--key", PUBLIC_KEY])
    assert_equal 1, result.status
    assert_match(/--key/, result.err)
  end
end
