# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  command_name "minitest"
  add_filter "/test/"
  add_filter "lib/valv/version.rb"
  add_filter "lib/valv/rails.rb"
  track_files "lib/**/*.rb"
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "valv"
Zeitwerk::Loader.eager_load_all

require "minitest/autorun"

module CLIHelper
  Result = Data.define(:status, :out, :err)

  class FakeTTY < StringIO
    def tty? = true
  end

  def cli(argv, out_tty: false, err_tty: false)
    out = out_tty ? FakeTTY.new : StringIO.new
    err = err_tty ? FakeTTY.new : StringIO.new
    status = Valv::CLI.start(argv, out:, err:)
    Result.new(status:, out: out.string, err: err.string)
  end
end

module TestFixtures
  PRIVATE_KEY = "LupoKAFUrJGJGSxOQEH9jSNx4N29oEfkbRiWXsn15QE="
  PUBLIC_KEY = "cUBo9LUaIdqBlL0ZoE9nrslf89zrXUTE6vEbiZOKp2Q="

  OTHER_PRIVATE_KEY = "j6j8wbg1rZqtyr9Om/kcpoi370HOKpzifMoXfY/yVcE="
  OTHER_PUBLIC_KEY = "D4J2whCyTA2DN7QKWdosZwWYn300Z3jWnW6Gt2HVHyM="
end
