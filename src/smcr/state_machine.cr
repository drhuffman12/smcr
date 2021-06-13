# require "./concerns/aliases.cr"
# require "./concerns/props_and_inits.cr"

module Smcr
  # include Aliases

  class StateMachine(State)
    include JSON::Serializable
    # include PropsAndInits(State)

    ERROR_KEY_PATHS_ALLOWED       = "paths_allowed"
    ERROR_KEY_STATE_CHANGE_FAILED = "history"

    getter state_default : State
    getter history_size : HistorySize
    getter tick : Tick
    getter state : State
    getter history : History
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
      history : History? = nil,
      paths_allowed : PathsAllowed? = nil
    )
      @history_size = history_size ? history_size : HistorySize.new(10)
      @tick = tick ? tick : Tick.new(0)

      @state_default = state_default ? state_default : State.values.first
      @state = state ? state : @state_default

      @history = history ? history : History.new
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

    # # PATHS

    def paths_allowed?(state_from, state_to)
      @paths_allowed.keys.includes?(state_from) && @paths_allowed[state_from].includes?(state_to)
    end

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

    # # ATTEMPT STATE CHANGE

    def attempt_state_change(
      forced : Bool,
      # from_tick : Tick, from_state : State,
      try_tick : Tick, try_state : State
    )
      response = callbacks_for(
        forced: forced,
        # from_tick: from_tick, from_state: from_state,
        try_tick: try_tick, try_state: try_state
      )

      attempt = {
        forced: forced,
        from:   {tick: tick, state_value: state.value},
        try:    {tick: try_tick, state_value: try_state.value},
        # state_value_became: StateValue,
        # tick_became: Tick,
        # state_change_attempted: StateChangedAttempt,
        callback_response: response,
      }

      if response[:succeeded]
        @tick = response[:to][:tick]
        @state = response[:to][:state_value]
      else
        @errors[ERROR_KEY_STATE_CHANGE_FAILED]
        log_failed_state_change(attempt)
      end

      @history << attempt
    end

    # # Modify these methods in sub-classes:

    def callbacks_for(
      forced : Bool,
      # from_tick : Tick, from_state : State,
      try_tick : Tick, try_state : State
    ) : CallbackResponse
      # Put callbacks in here in sub-class
      # TODO ...

      # Must return data with the following keys (hard-code values for now):
      {
        succeeded: succeeded,
        code:      code, # e.g.: mimic HTTP codes,
        to:        to,
        message:   message,
      }
    end

    def log_failed_state_change(attempt)
      # Normal use should be to Sub-class and mod this method to handle state change failures
    end
  end
end
