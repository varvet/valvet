require "yaml"

module Valv
  module YAML
    def self.register
      ::YAML.add_tag("!encrypted", Valv::Encrypted)
      ::YAML.add_tag("!public_key", Valv::PublicKey)
    end
  end

  class Encrypted
    def init_with(coder) = initialize(ciphertext: coder.scalar)

    def encode_with(coder)
      coder.scalar = ciphertext
    end
  end

  class PublicKey
    def init_with(coder) = initialize(key: coder.scalar)

    def encode_with(coder)
      coder.scalar = key
    end
  end

  class Store
    def to_yaml(...) = ::YAML.dump(@hash, ...)
  end
end
