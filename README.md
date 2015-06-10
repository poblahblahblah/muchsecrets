[![license](http://img.shields.io/badge/license-MIT-red.svg?style=flat)](https://raw.githubusercontent.com/poblahblahblah/muchsecrets/master/LICENSE)
[![Build Status](https://travis-ci.org/poblahblahblah/muchsecrets.svg)](https://travis-ci.org/poblahblahblah/muchsecrets)

**MuchSecrets** is a poorly named gem that handles encrypting and decrypting secrets to/from consul.

What's this useful for? Pulling encrypted secrets from [Consul](https://consul.io/), for one. Do you have multiple applications that need to fetch and decrypt secrets? Use a separate key pair for each application. Or not.

## Setting up your keypairs ##

1. create a passwordless keypair
```bash
:$ openssl req -new -newkey rsa:4096 -nodes -x509 -keyout application.pem -out application.pem
````

2. store your keypair some place safe.


## Usage ##

Use the command line executable to encrypt:
```
:$ muchsecrets --encrypt --publickey application.pem --string "such_privacy"

-----BEGIN PKCS7-----
MIIDMwYJKoZIhvcNAQcDoIIDJDCCAyACAQAxggLgMIIC3AIBADCBwzCBtTELMAkG
A1UEBhMCVVMxDzANBgNVBAgTBk9yZWdvbjERMA8GA1UEBxMIUG9ydGxhbmQxHjAc
BgNVBAoTFUdvbGRzdGFyIEV2ZW50cywgSW5jLjEeMBwGA1UECxMVc2hhcmVkLXBy
b2R1Y3Rpb24td2MxMSEwHwYDVQQDExhodHRwczovL3d3dy5nb2xkc3Rhci5jb20x
HzAdBgkqhkiG9w0BCQEWEG9wc0Bnb2xkc3Rhci5jb20CCQCASRiabrpfIjANBgkq
hkiG9w0BAQEFAASCAgAxVwDR9gvGQUayj34tJLcwjT5JDYHjf3RTdmf5HDANMgoy
WrJJY74hx5fskZLuvbptHI4/RDd/uB4LQHAiMel/wK/YSPcUC3rCDsII9L4jOc7o
K/rz9VPUAiVcGFfE4R1HQkYIcwKsgZg0FiImNZgxRCpx9Gn1YhxxY3+A46fRA2Ym
JcHJHfvLK0CMMmGU3Q3dTgpD9oZ2UWkWf1dw6XvtpaVs6BJNoA/9PDK6Teik++Om
gMuzd0VI8mxPoNBiH4GVpZzfKyUDg7zJQtELsTmVbwdae88I4wrIjZNEIg+2GBTC
wqsG+7jdMuP0YeTsKWLmAzOVyLfJmMzqMAJ5i31jvYFnyeDymjzLvJvly2mW1UdQ
6dJHFNyneK4uHsE8G5kJ9MoaYrZWtwA1DgaiNjCbaRqTfDScxGyYTE3gvJetU1Lx
H6wqht2HXzps61zSGAyeEac8CvTyub0ub86tEZ5GD4GU6VqKvEnvtoe/t1NK6E38
vc0t/lvY9zledBI/z+dp3IumCQcKhxX1V4JKxn3yB2WdXJZbFfg92pf/NtDeHdR8
PwcYuruEYYK8WF+cNApFsRmeAa+tL1J9f/K+4x65rhRja/fbTQFvWMe3hkybbgql
BZqnjg5EqoAk/yVoq9joGmjg6ujkezgNJJ0u1pvJi1QRQhA8v7nZ+swpqZ0fxjA3
BgkqhkiG9w0BBwEwHQYJYIZIAWUDBAEsBBB0gcWyiwNgAVMXLUCSfTrkgAsM77Vi
DClnGP48kw==
-----END PKCS7-----
```

Use the command line to decrypt directly from consul:
```
:$ muchsecrets --decrypt --publickey application.pem --privatekey application.pem --consul secrets/wow

foo bar baz
```

Or you can use it directly from your application.

To encrypt a string:
```ruby
require 'muchsecrets'
wow = MuchSecrets::Secret.new(:public_key => 'application.pem')
wow.encrypt_string("such_privacy")
# => "-----BEGIN PKCS7-----
MIIDIgYJKoZIhvcNAQcDoIIDEzCCAw8CAQAxggLNMIICyQIBADCBsDCBojELMAkG
A1UEBhMCVVMxDzANBgNVBAgTBk9yZWdvbjERMA8GA1UEBxMIUG9ydGxhbmQxHjAc
BgNVBAoTFUdvbGRzdGFyIEV2ZW50cywgSW5jLjETMBEGA1UECxMKT3BlcmF0aW9u
czEZMBcGA1UEAxMQd3d3LmdvbGRzdGFyLmNvbTEfMB0GCSqGSIb3DQEJARYQb3Bz
QGdvbGRzdGFyLmNvbQIJANt3J781eLGXMA0GCSqGSIb3DQEBAQUABIICACCoyYVm
3moYb3hZCl9fjgLRAzr1aW6mVGCbmRcHuJf/sFD91tBFG7i0/pHctvDtRKBMugER
Te0GMKghfPkQwbg6f2ksmsmJe0np4rx9RT28ZMl3ME6ywucxI3/2Qv8DfBW1QM+I
Erwrzw678PKDZygwriDJ+mCDbDB4i/J7jFHG6mjIeV9KilFnCW1M3h54N76+zjds
1wu4vQlG5x1F3zaJ/uDOTw4NbUBA3TGvTsWsPBQA86dbVjeONA7EEeIG4/pFINhe
qnMiii5zUpXymuM10vkjRWf081PH/V4Xc0LK93Ic5p5otO2kZTZfMFLMKxNTHlmP
/Bu+8kC2af6qXfGQZOYSZdU7/WDeo55xzC89lkN9q5Um1SrdUPIwUu7633/Mn9DJ
WHNad6ZIZdVHzA04u9OE0peR8aPb157PsU8OOWvtH22jAg9f60+qiCMaT+JSK4c2
VN81q1PL9jRfed48sz0fox/abCF14+oLEnWkU1yvToYFUD1kzmFgr4BApxIctM6B
COFy9Fxhwkznn5Xd7nH9ZAPB/t+pntgeLH65rqqAxgYovsw2hpXQKtiGdZlcpjH5
vobT/ULI+8xdBfzwR4sOZ1LCwwwMZuSqtaRRsJGkwCk1qmcfpt52VyWerCLYO/Z/
UYSWV18rcuBtpg0vnD8KbfUNI8K6Qggt2a+dMDkGCSqGSIb3DQEHATAdBglghkgB
ZQMEASwEEMVOg3shVq9U1O7CzSDJfSyADex+cL6h7RnV1tRwDqI=
-----END PKCS7-----"
```

Push the encrypted string to consul/whatever.

To decrypt a key value directly from consul:
```ruby
require 'muchsecrets'
wow = MuchSecrets::Secret.new(:public_key => 'application.pem', :private_key => 'application.pem')
super_secret = wow.get_consul_secret('notprod/github_api_key/encrypted') # would fetch http://consul:8500/v1/kv/notprod/github_api_key/encrypted?raw
# => "such_privacy"
```

To decrypt a key value directly from a web endpoint:
```ruby
require 'muchsecrets'
wow = MuchSecrets::Secret.new(:public_key => 'application.pem', :private_key => 'application.pem', :base_url => 'http://service:8080')
super_secret = wow.get_http_secret('notprod/github_api_key/encrypted') # would fetch http://service:8080/notprod/github_api_key/encrypted
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

