[![license](http://img.shields.io/badge/license-MIT-red.svg?style=flat)](https://raw.githubusercontent.com/poblahblahblah/muchsecrets/master/LICENSE)

**MuchSecrets** is a poorly named gem that handles rsautl encrypted + base64 encoded strings.

* Use a slightly modified public ssh key you can encrypt a string.
* Use an unmodified private ssh key you can decrypt the string and use it however you want.

What's this useful for? Pulling encrypted secrets from [Consul](https://consul.io/), for one. Do you have multiple applications that need to fetch and decrypt secrets? Use a separate key pair for each application. Or not.

## Setting up your keypairs ##

1. create a passwordless ssh keypair
```bash
:$ ssh-keygen -q -b 4096 -t rsa -f application.priv
````

2. convert public key to PEM format
```bash
:$ openssl rsa -in application.priv -out application.pub -outform PEM -pubout
```

3. store your private key some place safe

## Usage ##

To encrypt a string:
```ruby
require 'muchsecrets'
wow = MuchSecrets.new(:public_key => 'application.pub')
wow.encrypt_string("such_privacy")
# => "shMEuIBX9J5enEaqSa0yq8ZxVU9knW2ZGCng4nFrNxtY75OR3wcn3hZtHiaKEtzs\n9q+hBFG/1xylJUcGFvP+NbbgBDyFQYL9CEiTtqRJn/O100J8XcEe3pF2XNLukxqD\nMutRMhOkfaQJf4i1sH50kj0rsbi8Jta01XlIHAHefOcb0pNRr7cHWzVJ2g8eXKth\nXYnw5/YW2hT9K26xSzCjBK3L1aAkmuOPybXCrIHHb7tt6e+oLuBii42K8UuIRpCQ\n0vEBe5vKOPuF8QWQCyJs7ikwCBrbPyr8BEYJpxoS9hXbS3YK5xPAy2W3qjWhKHJ2\naf/SvovRyR5ovlhPFrqiew=="
```

To decrypt a raw key value from consul:
```ruby
require 'muchsecrets'
wow = MuchSecrets.new(:private_key => 'application.priv')
super_secret = wow.get_http_secret('http://consul/v1/kv/notprod/github_api_key/encrypted?raw')
# => "such_privacy"
```

## To Do ##

* come up with less awful method names
* write tests
* be able to encrypt and POST to consul
* more security

## Please Note ##

I am not a security expert. If something I am doing is terribly wrong please let me know!

## Contributors ##

