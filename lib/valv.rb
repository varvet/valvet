# frozen_string_literal: true

require_relative "valv/version"

require "rbnacl"
require "base64"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("yaml" => "YAML")
loader.ignore("#{__dir__}/valv/version.rb")
loader.ignore("#{__dir__}/valv/cli.rb")
loader.setup

module Valv
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
