# frozen_string_literal: true

require "test_helper"
require "valv/cli"

class Valv::CLITest < Minitest::Test
  include CLIHelper

  def test_help_with_no_args
    result = cli([])
    assert_equal 0, result.status
    assert_match(/keypair/, result.out)
    assert_match(/encrypt/, result.out)
    assert_match(/decrypt/, result.out)
  end

  def test_help_command
    result = cli(%w[help])
    assert_equal 0, result.status
    assert_match(/Usage:/, result.out)
  end

  def test_unknown_command_shows_help
    result = cli(%w[nonexistent])
    assert_equal 0, result.status
    assert_match(/Usage:/, result.out)
  end
end
