module Valvet
  module Crypto
    def self.encode(data) = Base64.strict_encode64(data)
    def self.decode(data) = Base64.decode64(data)

    def self.generate
      key = encode(RbNaCl::PrivateKey.generate.to_s)
      Decryptor.new(key)
    end

    class Encryptor
      def initialize(public_key)
        @public_key = RbNaCl::PublicKey.new(Crypto.decode(public_key))
      end

      def to_s = Crypto.encode(@public_key.to_s)

      def encrypt(plaintext)
        box = RbNaCl::Boxes::Sealed.from_public_key(@public_key)
        Crypto.encode(box.encrypt(plaintext))
      end
    end

    class Decryptor
      def initialize(private_key)
        @private_key = RbNaCl::PrivateKey.new(Crypto.decode(private_key))
      end

      def to_s = Crypto.encode(@private_key.to_s)
      def public_key = Crypto.encode(@private_key.public_key.to_s)

      def encryptor = Encryptor.new(public_key)

      def decrypt(ciphertext)
        box = RbNaCl::Boxes::Sealed.from_private_key(@private_key)
        box.decrypt(Crypto.decode(ciphertext))
      end
    end
  end
end
