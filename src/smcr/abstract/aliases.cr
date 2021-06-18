module Smcr
  module Abstract
    alias StateValue = Int32 # aka internal representation of an Enum's value

    alias HistorySize = UInt8 # Bigger?
    # alias History = Array(StateChanges)

    alias StatesAllowed = Array(StateValue)
    alias PathsAllowed = Hash(StateValue, StatesAllowed)

    alias CallbackResponse = NamedTuple(
      succeeded: Bool,
      code: Int32, # e.g.: mimic HTTP codes,
      message: String)

    # alias StateChangeAttempt = NamedTuple(
    #   resync: Bool,
    #   forced: Bool,
    #   from_state_value: StateValue,
    #   try_state_value: StateValue,
    #   callback_response: CallbackResponse)

    # alias History = Array(StateChangeAttempt)

    alias CurrentErrors = Hash(String, String)
  end
end
