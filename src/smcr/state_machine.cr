module Smcr
  alias StateValue = Int32 # aka internal representation of an Enum's value

  # alias CurrentErrors = Hash(Symbol, String)
  # alias State = T
  alias Tick = Int32        # Bigger?
  alias HistorySize = UInt8 # Bigger?
  # alias History = Array(StateChanges)

  alias StatesAllowed = Array(StateValue)
  alias PathsAllowed = Hash(StateValue, StatesAllowed)

  alias StateChangedAttempt = NamedTuple(
    forced: Bool,
    from: {state_value: StateValue, tick: Tick},
    to: {state_value: StateValue, tick: Tick})
  alias CallbackResponse = NamedTuple(
    succeeded: Bool,
    code: Int32, # e.g.: mimic HTTP codes
    message: String)
  alias StateChange = NamedTuple(
    state_value_became: StateValue,
    tick_became: Tick,
    state_change_attempted: StateChangedAttempt,
    callback_response: CallbackResponse)
  alias StateChangeHistory = Array(StateChange)

  alias CurrentErrors = Hash(String, String)

  class StateMachine(State)
    include JSON::Serializable

    # STATE_NOT_SET = :state_not_set
    ERROR_KEY_PATHS_ALLOWED = "paths_allowed"

    getter state_default : State
    getter history_size : HistorySize
    getter tick : Tick
    getter state : State
    getter history : StateChangeHistory
    getter paths_allowed : PathsAllowed

    getter errors : CurrentErrors

    def self.state_class
      State # Needed? Maybe just in case we want to programmatically remind our selves what the 'State' class is?
    end

    def self.state_names
      State.names # Needed?
    end

    def self.state_values
      State.values # Needed?
    end

    def self.state_internal_values
      State.values.map(&.value) # Needed?
    end

    def initialize(
      state_default : State? = nil,
      history_size : HistorySize? = nil,
      tick : Tick? = nil,
      state : State? = nil,
      history : StateChangeHistory? = nil,
      paths_allowed : PathsAllowed? = nil
    )
      @history_size = history_size ? history_size : HistorySize.new(10)
      @tick = tick ? tick : Tick.new(0)

      @state_default = state_default ? state_default : State.values.first
      @state = state ? state : @state_default

      @history = history ? history : StateChangeHistory.new
      @paths_allowed = paths_allowed ? paths_allowed : PathsAllowed.new # initial_default_path
      init_paths

      @errors = CurrentErrors.new
      validate
    end

    def validate
      @errors = CurrentErrors.new

      if @paths_allowed.keys.empty? || @paths_allowed.values.map(&.empty?).all?
        @errors[ERROR_KEY_PATHS_ALLOWED] = "must be an mapping of state to array of states"
      end

      @errors
    end

    def valid?
      @errors.empty?
    end

    ####

    def paths_allowed?(state_from, state_to)
      @paths_allowed.keys.includes?(state_from) && @paths_allowed[state_from].includes?(state_to)
    end

    # def initial_default_path
    #   value_first = State.values.first.value
    #   values_all = State.values.map(&.value) # .map{|val| val}
    #   values_other = values_all - [value_first]
    #   {value_first => values_other}
    # end

    def init_paths
      self.class.state_values.each do |state_from|
        init_paths_from(state_from)
      end
    end

    def init_paths_from(state_from)
      @paths_allowed[state_from.value] = StatesAllowed.new
    end

    def add_path(state_from, state_to)
      init_paths_from(state_from) unless @paths_allowed.keys.includes?(state_from.value)

      # You can effectively re-order 'state_to' values by re-add a 'state_to' value (which gets moved to the end).
      remove_path(state_from, state_to)

      @paths_allowed[state_from.value] << state_to.value
    end

    def remove_path(state_from, state_to)
      @paths_allowed[state_from.value].delete(state_to.value) if @paths_allowed[state_from.value].includes?(state_to.value)
    end
  end
end
