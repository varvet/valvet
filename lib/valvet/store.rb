module Valvet
  class Store
    Decrypt = Data.define(:public_key, :ciphertext)
    Encrypt = Data.define(:public_key, :plaintext)

    def initialize(hash, public_key: nil, &handler)
      @hash = hash
      @handler = handler
      @public_key = find_public_key(hash)&.key || public_key
    end

    def key?(key) = @hash.key?(key)

    def each(path: [], &block)
      @hash.each do |key, value|
        case value
        when Valvet::PublicKey
          next
        when Valvet::Encrypted
          yield path + [key], value, self
        when Hash
          child_scope(value).each(path: path + [key], &block)
        else
          yield path + [key], value, self
        end
      end
    end

    def to_h
      @hash.each_with_object({}) do |(key, value), result|
        next if value.is_a?(Valvet::PublicKey)
        result[key] = resolve(key)
        result[key] = result[key].to_h if result[key].is_a?(self.class)
      end
    end

    def resolve(key)
      value = @hash[key]
      case value
      when Valvet::Encrypted then decrypt(value)
      when Hash then child_scope(value)
      else value
      end
    end

    def method_missing(name, ...)
      key = name.to_s
      if key.end_with?("=")
        assign(key.chomp("="), ...)
      elsif @hash.key?(key)
        resolve(key)
      else
        super
      end
    end

    def respond_to_missing?(name, ...)
      key = name.to_s
      @hash.key?(key) || (key.end_with?("=") && @hash.key?(key.chomp("="))) || super
    end

    private

    def assign(key, value)
      if @hash[key].is_a?(Valvet::Encrypted)
        ciphertext = @handler.call(Encrypt.new(@public_key, value))
        @hash[key] = Valvet::Encrypted.new(ciphertext:)
      else
        @hash[key] = value
      end
    end

    def decrypt(encrypted)
      @handler.call(Decrypt.new(@public_key, encrypted.ciphertext))
    end

    def child_scope(hash)
      self.class.new(hash, public_key: @public_key, &@handler)
    end

    def find_public_key(hash)
      hash.each_value { |v| return v if v.is_a?(Valvet::PublicKey) }
      nil
    end
  end
end
