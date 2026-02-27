module Valvet
  module Error
    class Base < StandardError
    end

    class NoDecryptorError < Base
      attr_reader :public_key
      attr_reader :ciphertext

      def initialize(public_key:, ciphertext:)
        @public_key = public_key
        @ciphertext = ciphertext
        super("No decryptor for public key #{public_key}")
      end
    end
  end
end
