require 'spec_helper'

describe MuchSecrets::Secret do

  let(:base_url) {nil}
  let(:cipher) {nil}

  subject :instance do
    described_class.new({private_key: 'spec/data/tests.pem', public_key: 'spec/data/tests.pem', base_url: base_url})
  end

  describe "#get_http_secret" do
    subject do
      instance.get_http_secret('path/to/secret')
    end

    before do
      allow(Net::HTTP).to receive(:get).and_return(File.read('spec/data/encrypted.secret'))
    end

    it "returns decrypted secret" do
      expect(subject).to eq("foo")
    end

    it "fetches the http secret from the default base url" do
      expect(Net::HTTP).to receive(:get).with(URI("http://localhost:8500/v1/kv/path/to/secret"))

      subject
    end

    context "when a base url is provided" do
      let(:base_url) {"http://localconsul:8500/v1/kv"}

      it "fetches the http secret from the provided base url" do
        expect(Net::HTTP).to receive(:get).with(URI("http://localconsul:8500/v1/kv/path/to/secret"))

        subject
      end
    end

  end

  describe "#get_consul_secret" do

    subject do
      instance.get_consul_secret("path/to/secret")
    end

    before do
      allow(instance).to receive(:get_http_secret).and_return("foo")
    end

    it "appends ?raw to uri" do
      expect(instance).to receive(:get_http_secret).with ("path/to/secret?raw")

      subject
    end

    it "returns raw secret" do
      expect(subject).to eq("foo")
    end
  end

  describe "#encrypt_string" do
    subject do
      instance.encrypt_string("foo")
    end

    let(:certificate) {double(:certificate)}
    let(:cipher_instance) {double(:cipher_instance)}

    before do
      allow(OpenSSL::X509::Certificate).to receive(:new).and_return(certificate)
      allow(OpenSSL::PKCS7).to receive(:encrypt).and_return("foobar")
    end

    it "creates a new certificate with public_key" do
      expect(OpenSSL::X509::Certificate).to receive(:new).with (File.read("spec/data/tests.pem"))

      subject
    end

    it "encrypts the secret with the certificate" do
      expect(OpenSSL::Cipher).to receive(:new).with("AES-256-CFB").and_return(cipher_instance)
      expect(OpenSSL::PKCS7).to receive(:encrypt).with([certificate], "foo", cipher_instance, OpenSSL::PKCS7::BINARY)

      subject
    end

    it "returns an encrypted string" do
      expect(subject).to eq("foobar")
    end

  end

end

