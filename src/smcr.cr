# TODO: Write documentation for `Smcr`
require "json"
require "./smcr/*"

module Smcr
  VERSION       = {{ `shards version "#{__DIR__}"`.chomp.stringify }}
  DEBUG_ENABLED = ENV.keys.includes?("CRYSTAL_DEBUG") && !ENV["CRYSTAL_DEBUG"].empty?

  alias StateValue = Int32 # aka internal representation of an Enum's value

  alias Tick = Int32        # Bigger?
  alias HistorySize = UInt8 # Bigger?
  # alias History = Array(StateChanges)

  alias StatesAllowed = Array(StateValue)
  alias PathsAllowed = Hash(StateValue, StatesAllowed)

  alias StateAtTick = NamedTuple(tick: Tick, state_value: StateValue)

  # alias StateChangedAttempt = NamedTuple(
  #   forced: Bool,
  #   from: StateAtTick,
  #   try: StateAtTick)
  alias CallbackResponse = NamedTuple(
    succeeded: Bool,
    to: StateAtTick,
    code: Int32, # e.g.: mimic HTTP codes,
    message: String)

  # alias StateChangeAttempt = NamedTuple(
  #   # state_value_became: StateValue,
  #   # tick_became: Tick,
  #   state_change_attempted: StateChangedAttempt,
  #   callback_response: CallbackResponse)

  alias StateChangeAttempt = NamedTuple(
    resync: Bool,
    forced: Bool,
    from: StateAtTick,
    try: StateAtTick,
    # state_value_became: StateValue,
    # tick_became: Tick,
    # state_change_attempted: StateChangedAttempt,
    callback_response: CallbackResponse)

  alias History = Array(StateChangeAttempt)

  alias CurrentErrors = Hash(String, String)
end

p! Smcr::VERSION if Smcr::DEBUG_ENABLED
