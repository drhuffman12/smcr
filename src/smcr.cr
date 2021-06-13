# TODO: Write documentation for `Smcr`
require "./smcr/*"

module Smcr
  VERSION       = {{ `shards version "#{__DIR__}"`.chomp.stringify }}
  DEBUG_ENABLED = ENV.keys.includes?("CRYSTAL_DEBUG") && !ENV["CRYSTAL_DEBUG"].empty?
end

p! Smcr::VERSION if Smcr::DEBUG_ENABLED
