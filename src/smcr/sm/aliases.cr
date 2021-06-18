require "./../abstract/aliases.cr"

module Smcr
  module Sm
    # alias Smcr::Abstract::StateValue = Int32 # aka internal representation of an Enum's value
    # alias HistorySize = UInt8 # Bigger?
    # alias History = Array(StateChanges)

    # alias StatesAllowed = Array(Abstract::StateValue)
    # alias PathsAllowed = Hash(Abstract::StateValue, StatesAllowed)

    # alias CallbackResponse = NamedTuple(
    #   succeeded: Bool,
    #   to: AttemptSummary, # State,
    #   code: Int32, # e.g.: mimic HTTP codes,
    #   message: String)

    # alias StateChangeAttempt = NamedTuple(
    #   resync: Bool,
    #   forced: Bool,
    #   # from_state_value: Smcr::Abstract::StateValue,
    #   # try_state_value: Smcr::Abstract::StateValue,
    #   from: AttemptSummary, # State,
    #   attempting: AttemptSummary, # State,
    #   callback_response: Smcr::Abstract::CallbackResponse)

    # alias History = Array(StateChangeAttempt)

    # alias CurrentErrors = Hash(String, String)
  end
end
