module MuchSecrets
  class Secret
    require 'openssl'
    require 'net/http'

    def initialize(options = {})
      @private_key = options[:private_key]
      @public_key  = options[:public_key]
      @base_url    = options[:base_url] || "http://consul:8500/v1/kv" 
      @cipher      = OpenSSL::Cipher.new(options[:cipher] || "AES-256-CFB")
    end

    def get_http_secret(uri)
      encrypted_secret = fetch_encrypted_http_secret(uri)
      return decrypt_string(encrypted_secret)
    end

    def encrypt_string(val)
      cert = OpenSSL::X509::Certificate.new(File.read(@public_key))
      return OpenSSL::PKCS7::encrypt([cert], val, @cipher, OpenSSL::PKCS7::BINARY)
    end

    private

    def fetch_encrypted_http_secret(uri)
      # get the secret from the http endpoint
      uri = File.join(@base_url, uri)
      return Net::HTTP.get(URI(uri)).chomp
    end

    def decrypt_string(val)
      cert = OpenSSL::X509::Certificate.new(File.read(@public_key))
      key  = OpenSSL::PKey::RSA.new(File.read(@private_key))
      return OpenSSL::PKCS7.new(val).decrypt(key, cert)
    end
  end
end

