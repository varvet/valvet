# Valv

Keep secrets in your config files. Valv encrypts sensitive values while leaving everything else readable, so you can check the whole file into version control, just like Rails credentials.

It uses asymmetric encryption ([NaCl sealed boxes](https://libsodium.gitbook.io/doc/public-key_cryptography/sealed_boxes) via [RbNaCl](https://github.com/RbNaCl/rbnacl)), which means anyone on the team can add new secrets using the public key — without ever needing the private key.

Give each environment its own keypair and they can all live in one file, each unable to decrypt the other's secrets.

## Usage

## CLI

Generate a keypair (public key to stdout, private key to stderr):

```bash
valv keypair                            # prints both, labeled
valv keypair > public.key 2> private.key  # saves each to a file
```

Encrypt and decrypt individual values:

```bash
valv encrypt "my secret" --key public.key
valv decrypt "ciphertext..." --key private.key
```

## Config files

Put your config in a YAML file with `!public_key` and `!encrypted` tags:

```yaml
development:
  public_key: !public_key cWgtEYZ3bDXYgiHGbanGr+vl4HQrDgiAmOlBRc+hhgo=
  secret_key_base: !encrypted 7oc+QbPyIa3Oe4ty09tNWRhgkAvlFjyWcggfeRAz8olE5VRF3lNvJEVGs8xgGquoXvItXPWOfus0ntQaUphFEsANyAE=
  database:
    password: !encrypted 3ad2zo3NKQU1EZm7XB2uFiqE6wAWjPPqjvPTD8rUB3m+ya2xrE5YvEuxDYkswgxqMjRfm5V1OHyz4cnez0GLUTif1+0=

production:
  public_key: !public_key R7ljpsyGiOm2Yz3ElbQwCDDapAMEhCHl6WYWS/ep4vM=
  secret_key_base: !encrypted HWZrJnY+AxBW5+W71Ar6DHkW2clqmtccrcCy5iek+9H4BfYTS1VR5/P3p+YhNzIgd7+MTTJxSTXmGeG9k0CQfoUpnn0=
  database:
    password: !encrypted 8Z2QiPc7gKWqTmjs6mlNiKWPJ997ftzgpiMO/NdEEjzAvXAAckYIqeyOxem+OeCsDHsCwM8j2x8XPH/7VM383dmw+jA=
```

## Rails

Place your config in `config/valv.yml` and set `VALV_PRIVATE_KEY` in your environment. The Railtie is loaded automatically and exposes `Rails.configuration.valv`:

```ruby
Rails.configuration.valv.secret_key_base
Rails.configuration.valv.database.password
```

## Installation

```bash
bundle add valv
```

## Development

```bash
bin/setup
rake          # runs tests, linting, and RBS validation
```

## License

[MIT](LICENSE.txt)
