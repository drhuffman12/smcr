
module Smcr
  module Tsm
    # alias Abstract::StateValue = Int32 # aka internal representation of an Enum's value

    alias Tick = Int32        # Bigger?
    # alias HistorySize = UInt8 # Bigger?
    # alias History = Array(StateChanges)
  
    # alias StatesAllowed = Array(Abstract::StateValue)
    # alias PathsAllowed = Hash(Abstract::StateValue, StatesAllowed)
  
    alias StateAtTick = NamedTuple(tick: Tick, state_value: Abstract::StateValue)
  
    # alias Abstract::CallbackResponse = NamedTuple(
    #   succeeded: Bool,
    #   to: StateAtTick,
    #   code: Int32, # e.g.: mimic HTTP codes,
    #   message: String)
  
    alias StateChangeAttempt = NamedTuple(
      resync: Bool,
      forced: Bool,
      from: StateAtTick,
      try: StateAtTick,
      callback_response: Abstract::CallbackResponse)
  
    alias History = Array(StateChangeAttempt)
  
    # alias CurrentErrors = Hash(String, String)
  end
end
