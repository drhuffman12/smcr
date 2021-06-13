# smcr

State Machine for Crystal

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     smcr:
       github: drhuffman12/smcr
   ```

2. Run `shards install`

## Usage

```crystal
require "smcr"
```

TODO: Write usage instructions here

## Development

To enable debug comment logging, set `CRYSTAL_DEBUG` env variable to anything other than an empty string. For example:

```
# debug logging enabled
CRYSTAL_DEBUG=soME_nOn_Blank_VALue crystal spec

# debug logging disabled
CRYSTAL_DEBUG= crystal spec
```

This will show at least:
```
Smcr::VERSION # => "0.1.0"
```

Use this to output additional debug info like:
```
p! Smcr::VERSION if Smcr::DEBUG_ENABLED
```



## Contributing

1. Fork it (<https://github.com/drhuffman12/smcr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Daniel Huffman](https://github.com/drhuffman12) - creator and maintainer
