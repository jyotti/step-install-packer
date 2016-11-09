# wercker step install-packer

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