# frozen_string_literal: true

require "test_helper"
require "valv/cli"

class Valv::CLI::DecryptTest < Minitest::Test
  include CLIHelper
  include TestFixtures

  def test_outputs_plaintext
    ciphertext = Valv::Crypto::Encryptor.new(PUBLIC_KEY).encrypt("secret")
    result = cli(["decrypt", ciphertext, "--key", PRIVATE_KEY])
    assert_equal 0, result.status
    assert_equal "secret", result.out.strip
  end

  def test_short_flag
    ciphertext = Valv::Crypto::Encryptor.new(PUBLIC_KEY).encrypt("secret")
    result = cli(["d", ciphertext, "-k", PRIVATE_KEY])
    assert_equal 0, result.status
    assert_equal "secret", result.out.strip
  end

  def test_missing_key_returns_1
    result = cli(%w[decrypt someciphertext])
    assert_equal 1, result.status
    assert_match(/--key/, result.err)
  end
end
