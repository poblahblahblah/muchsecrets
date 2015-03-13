[![license](http://img.shields.io/badge/license-MIT-red.svg?style=flat)](https://raw.githubusercontent.com/poblahblahblah/muchsecrets/master/LICENSE)

**MuchSecrets** is a poorly named gem that handles encrypting and decrypting secrets to/from consul.

What's this useful for? Pulling encrypted secrets from [Consul](https://consul.io/), for one. Do you have multiple applications that need to fetch and decrypt secrets? Use a separate key pair for each application. Or not.

## Setting up your keypairs ##

1. create a passwordless keypair
```bash
:$ openssl req -new -newkey rsa:4096 -nodes -x509 -keyout application.pem -out application.pem
````

2. store your private key some place safe

## Usage ##

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

Push the encrypted string to consul.

To decrypt a raw key value from consul:
```ruby
require 'muchsecrets'
wow = MuchSecrets::Secret.new(:public_key => 'application.pem', :private_key => 'application.pem')
super_secret = wow.get_http_secret('notprod/github_api_key/encrypted?raw')
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

