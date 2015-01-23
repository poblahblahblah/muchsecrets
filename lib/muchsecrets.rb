class MuchSecrets

  def initialize(options = {})
    @private_key = options[:private_key] # to decrypt
    @public_key  = options[:public_key]  # to encrypt
    # @base_url    = options[:base_url]  # for future use
  end

  def get_http_secret(uri)
    encrypted_secret = fetch_encrypted_http_secret(uri)
    tmpfile          = write_secret_to_tempfile(encrypted_secret)
    return decrypt_tempfile(tmpfile)
  end

  def encrypt_string(val)
    return `echo #{val} | openssl rsautl -pubin -inkey #{@public_key} -encrypt -pkcs | openssl enc -base64`.chomp
  end

  private

  def fetch_encrypted_http_secret(uri)
    # get the secret from the http endpoint
    require 'net/http'
    uri    = URI(uri)
    secret = Net::HTTP.get(uri).chomp
  end

  def write_secret_to_tempfile(secret)
    # write the secret to a tempfile, return the tempfile path
    require 'tempfile'
    tmpfile = Tempfile.new('muchsecrets')
    tmpfile.write(secret)
    tmpfile.rewind
    return tmpfile.path
  end

  def decrypt_tempfile(tmpfile)
    return `openssl enc -base64 -d -in #{tmpfile} | openssl rsautl -inkey #{@private_key} -decrypt`.chomp
  end
end

