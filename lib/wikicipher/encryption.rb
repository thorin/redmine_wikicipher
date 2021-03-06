module Wikicipher::Encryption

  def secret_key
    return @secret_key if @secret_key

    stored_key = Setting.plugin_redmine_wikicipher[:secret_key]
    if stored_key.try(:strip).blank?
      Setting.plugin_redmine_wikicipher = {
        :secret_key => (stored_key = random_key)
      }
    end

    @secret_key = Digest::SHA256.hexdigest(stored_key)
  end

  def encrypt(originalText)
    cipher = OpenSSL::Cipher::Cipher.new 'DES-EDE3-CBC'
    cipher.pkcs5_keyivgen(secret_key)
    cipher.encrypt
    s = cipher.update originalText
    s << cipher.final

    s.unpack('H*')[0].upcase
  end

  def decrypt(encodedContent)
    bytes = encodedContent.lines.to_a.pack("H*").unpack("C*").pack("c*")
    cipher = OpenSSL::Cipher::Cipher.new 'DES-EDE3-CBC'
    begin
      cipher.pkcs5_keyivgen(secret_key)
      cipher.decrypt
      s = cipher.update bytes
      s << cipher.final
    rescue OpenSSL::Cipher::CipherError
      cipher.reset
      cipher.decrypt secret_key
      s = cipher.update bytes
      s << cipher.final
    end
  end

  def random_key
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    (0...50).map{ o[rand(o.length)] }.join
  end
end