require "./../abstract/aliases.cr"

module Smcr
  module Tsm
    # alias Smcr::Abstract::StateValue = Int32 # aka internal representation of an Enum's value

    alias Tick = Int32 # Bigger?
    # alias HistorySize = UInt8 # Bigger?
    # alias History = Array(StateChanges)

    # alias StatesAllowed = Array(Abstract::StateValue)
    # alias PathsAllowed = Hash(Abstract::StateValue, StatesAllowed)

    # alias StateAtTick = NamedTuple(tick: Tick, state_value: Smcr::Abstract::StateValue)
    # alias StateAtTick = NamedTuple(tick: Tick, state: Smcr::Abstract::State)

    # alias CallbackResponse = NamedTuple(
    #   succeeded: Bool,
    #   to: StateAtTick,
    #   code: Int32, # e.g.: mimic HTTP codes,
    #   message: String)

    # alias StateChangeAttempt = NamedTuple(
    #   resync: Bool,
    #   forced: Bool,
    #   from: AttemptSummary, # StateAtTick,
    #   # try: StateAtTick,
    #   attempting: AttemptSummary, # StateAtTick,
    #   callback_response: Smcr::Abstract::CallbackResponse)

    # alias History = Array(StateChangeAttempt)

    # alias CurrentErrors = Hash(String, String)
  end
end
