module Valvet
  Encrypted = Data.define(:ciphertext) do
    def empty? = ciphertext.empty?
  end
end
