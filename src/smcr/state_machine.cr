module Smcr
  alias CurrentErrors = Hash(Symbol, String)
  alias State = Symbol
  alias Tick = Int32        # Bigger?
  alias HistorySize = UInt8 # Bigger?
  # alias History = Array(StateChanges)

  alias StatesAllowed = Array(State)
  alias PathsAllowed = Hash(State, StatesAllowed)

  alias StateChangedAttempt = NamedTuple(
    forced: Bool,
    from: {state: State, tick: Tick},
    to: {state: State, tick: Tick})
  alias CallbackResponse = NamedTuple(
    suceeded: Bool,
    code: Int32, # e.g.: mimic HTTP codes
    message: String)
  alias StateChange = NamedTuple(
    state_became: State,
    tick_became: Tick,
    state_change_attempted: StateChangedAttempt,
    callback_response: CallbackResponse)
  alias StateChangeHistory = Array(StateChange)

  class StateMachine
    include JSON::Serializable

    STATE_NOT_SET = :state_not_set

    getter states_allowed : StatesAllowed
    getter state_default : State
    getter history_size : HistorySize
    getter tick : Tick
    getter state : State
    getter history : StateChangeHistory
    getter paths_allowed : PathsAllowed

    getter errors : CurrentErrors

    # ameba:disable Metrics/CyclomaticComplexity
    def initialize(
      states_allowed : StatesAllowed? = nil,
      state_default : State? = nil,
      history_size : HistorySize? = nil,
      tick : Tick? = nil,
      state : State? = nil,
      history : StateChangeHistory? = nil,
      paths_allowed : PathsAllowed? = nil
    )
      @states_allowed = states_allowed ? states_allowed : StatesAllowed.new
      @history_size = history_size ? history_size : HistorySize.new(10)
      @tick = tick ? tick : Tick.new(0)

      @state_default = case
                       when state_default && state_allowed?(state_default)
                         state_default
                       when @states_allowed.nil? || @states_allowed.empty?
                         STATE_NOT_SET
                       else
                         @states_allowed.first
                       end
      @state = state ? state : @state_default

      @history = history ? history : StateChangeHistory.new
      @paths_allowed = paths_allowed ? paths_allowed : PathsAllowed.new

      @errors = validate
    end

    # ameba:enable Metrics/CyclomaticComplexity

    def validate
      errors = CurrentErrors.new

      errors[:states_allowed] = "must be populated with states" if @states_allowed.empty?
      errors[:state_default] = "must be one of state_allowed" unless state_allowed?(state_default)
      errors[:states] = "must be set" if @state == :error_state_unset
      errors[:states] = "must be one of state_allowed" unless state_allowed?(@state)
      errors[:paths_allowed] = "must be an mapping of state to array of states" if @paths_allowed.keys.empty?

      errors
    end

    def valid?
      @errors.empty?
    end

    ####

    def state_allowed?(state_example)
      @states_allowed.includes?(state_example)
    end

    def paths_allowed?(state_from, state_to)
      @paths_allowed.keys.includes?(state_from) && @paths_allowed[state_from].includes?(state_to)
    end

    def add_path(state_from, state_to)
      @paths_allowed[state_from] = StatesAllowed.new unless @paths_allowed.keys.includes?(state_from)
      @paths_allowed[state_from] << state_to
    end
  end
end
