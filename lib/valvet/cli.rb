# frozen_string_literal: true

require "optparse"

module Valvet
  class CLI
    def self.start(argv, ...)
      new(...).run(argv.dup)
    end

    def initialize(out: $stdout, err: $stderr)
      @out = out
      @err = err
      @commands = {
        "keypair" => method(:keypair), "g" => method(:keypair),
        "encrypt" => method(:encrypt), "e" => method(:encrypt),
        "decrypt" => method(:decrypt), "d" => method(:decrypt),
        "help" => method(:help)
      }
    end

    def run(argv)
      command = @commands.fetch(argv.shift.to_s) { method(:help) }
      command.call(argv) || 0
    end

    private

    def keypair(_argv)
      decryptor = Crypto.generate

      if @out.tty?
        @out.puts "public_key: #{decryptor.public_key}"
      else
        @out.puts decryptor.public_key
      end

      if @err.tty?
        @err.puts "private_key: #{decryptor}"
        @err.puts "\e[33mKeep the private key secret. Store it in an environment variable, not in version control.\e[0m"
      else
        @err.puts decryptor
      end
    end

    def encrypt(argv)
      key = nil
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: valvet encrypt VALUE --key PUBLIC_KEY"
        opts.on("-k", "--key KEY", "Public key (base64 or file path)") { |k| key = k }
      end
      parser.parse!(argv)

      value = argv.shift
      if value.nil? || key.nil?
        @err.puts parser.to_s
        return 1
      end

      @out.puts Crypto::Encryptor.new(read_key(key)).encrypt(value)
    end

    def decrypt(argv)
      key = nil
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: valvet decrypt CIPHERTEXT --key PRIVATE_KEY"
        opts.on("-k", "--key KEY", "Private key (base64 or file path)") { |k| key = k }
      end
      parser.parse!(argv)

      ciphertext = argv.shift
      if ciphertext.nil? || key.nil?
        @err.puts parser.to_s
        return 1
      end

      @out.puts Crypto::Decryptor.new(read_key(key)).decrypt(ciphertext)
    end

    def read_key(key)
      File.exist?(key) ? File.binread(key).strip : key
    end

    def help(_argv)
      @out.puts <<~HELP
        Usage: valvet COMMAND [OPTIONS]

        Commands:
          keypair, g     Generate a new keypair
          encrypt, e     Encrypt a value (requires --key)
          decrypt, d     Decrypt a value (requires --key)
          help           Show this help

        Run `valvet COMMAND --help` for more information.
      HELP
    end
  end
end
