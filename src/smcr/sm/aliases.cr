
module Smcr
  module Sm
    # alias Abstract::StateValue = Int32 # aka internal representation of an Enum's value

    # alias HistorySize = UInt8 # Bigger?
    # alias History = Array(StateChanges)
  
    # alias StatesAllowed = Array(Abstract::StateValue)
    # alias PathsAllowed = Hash(Abstract::StateValue, StatesAllowed)
  
    # alias Abstract::CallbackResponse = NamedTuple(
    #   succeeded: Bool,
    #   code: Int32, # e.g.: mimic HTTP codes,
    #   message: String)
  
    alias StateChangeAttempt = NamedTuple(
      resync: Bool,
      forced: Bool,
      from_state_value: Abstract::StateValue,
      try_state_value: Abstract::StateValue,
      callback_response: Abstract::CallbackResponse)
  
    alias History = Array(StateChangeAttempt)
  
    # alias CurrentErrors = Hash(String, String)
  end
end
