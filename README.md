# install-packer

[![wercker status](https://app.wercker.com/status/ec3070c41f744eea3a29d59b81a1a52b/s/master "wercker status")](https://app.wercker.com/project/bykey/ec3070c41f744eea3a29d59b81a1a52b)

A wercker step for install [Packer](https://www.packer.io/).

**install location**

- /usr/local/src or `$WERCKER_CACHE_DIR`/usr/local/src

## Options

- `version`(required) set packer version
- `use-cache` (optional, default:true) install to `WERCKER_CACHE_DIR`

## Example

```yaml
build:
  steps:
    - jyotti/install-packer:
      version: 0.11.0
```