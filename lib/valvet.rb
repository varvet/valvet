# frozen_string_literal: true

require_relative "valvet/version"

require "rbnacl"
require "base64"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("yaml" => "YAML")
loader.ignore("#{__dir__}/valvet/version.rb")
loader.ignore("#{__dir__}/valvet/cli.rb")
loader.ignore("#{__dir__}/valvet/rails.rb")
loader.setup

module Valvet
  def self.new(hash, private_keys: [])
    decryptors = private_keys.to_h do |private_key|
      decryptor = Crypto::Decryptor.new(private_key)
      [decryptor.public_key, decryptor]
    end

    Store.new(hash) do |intent|
      case intent
      in Store::Decrypt(public_key:, ciphertext:)
        decryptors.fetch(public_key) {
          raise Error::NoDecryptorError.new(public_key:, ciphertext:)
        }.decrypt(ciphertext)
      in Store::Encrypt(public_key:, plaintext:)
        Crypto::Encryptor.new(public_key).encrypt(plaintext)
      end
    end
  end
end

require "valvet/rails" if defined?(Rails::Railtie)
