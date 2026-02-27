# frozen_string_literal: true

require "test_helper"
require "valvet/cli"

class Valvet::CLI::KeypairTest < Minitest::Test
  include CLIHelper

  def test_piped_outputs_raw_keys
    result = cli(%w[keypair])
    assert_equal 0, result.status
    refute_match(/public_key:/, result.out)
    refute_match(/private_key:/, result.err)
    refute_empty result.out.strip
    refute_empty result.err.strip
  end

  def test_piped_keys_are_valid
    result = cli(%w[keypair])
    public_key = result.out.strip
    private_key = result.err.strip
    ciphertext = Valvet::Crypto::Encryptor.new(public_key).encrypt("test")
    assert_equal "test", Valvet::Crypto::Decryptor.new(private_key).decrypt(ciphertext)
  end

  def test_tty_labels_both_and_warns
    result = cli(%w[keypair], out_tty: true, err_tty: true)
    assert_match(/^public_key:/, result.out)
    assert_match(/^private_key:/, result.err)
    assert_match(/Keep the private key secret/, result.err)
  end

  def test_stdout_piped_stderr_tty
    result = cli(%w[keypair], out_tty: false, err_tty: true)
    refute_match(/public_key:/, result.out)
    assert_match(/^private_key:/, result.err)
  end

  def test_stdout_tty_stderr_piped
    result = cli(%w[keypair], out_tty: true, err_tty: false)
    assert_match(/^public_key:/, result.out)
    refute_match(/private_key:/, result.err)
  end

  def test_alias
    result = cli(%w[g])
    assert_equal 0, result.status
    refute_empty result.out.strip
  end
end
