require 'minitest/autorun'
require 'muchsecrets'

class MuchSecretsTest < Minitest::Test
  def test_hello
    assert_equal "hello world",
      MuchSecrets.http_fetch_secret('http://localhost:8500/v1/kv/test/plain?raw')
  end
end
