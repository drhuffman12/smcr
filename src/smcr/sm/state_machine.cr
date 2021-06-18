
require "./../abstract/state_machine.cr"
require "./aliases.cr"

module Smcr
  module Sm
    # Simple State Machine
    class StateMachine(State) < Abstract::StateMachine(State)
      # include JSON::Serializable

      # ERROR_KEY_PATHS_ALLOWED       = "paths_allowed"
      # ERROR_KEY_RESYNC_NEEDED       = "error_key_resync_needed"
      # ERROR_KEY_STATE_CHANGE_FAILED = "history"
  
      # getter state_default : State
      # getter history_size : Abstract::HistorySize
      # getter state : State
      getter history : Smcr::Sm::History
      # getter paths_allowed : Abstract::PathsAllowed
  
      # getter errors : Abstract::CurrentErrors
  
      # def self.state_class
      #   State # Needed? Maybe just in case we want to programmatically remind our selves what the 'State' class is?
      # end
  
      # def self.state_names
      #   State.names # Needed?
      # end
  
      # def self.state_values
      #   State.values # Needed?
      # end
  
      # def state_other_values(not_counting_state : State = state)
      #   StateMachine(State).state_values - [not_counting_state] # Needed?
      # end
  
      # def self.state_internal_values
      #   State.values.map(&.value) # Needed?
      # end
  
      # def other_state_internal_values
      #   StateMachine(State).state_internal_values - [state.value] # Needed?
      # end
  
      # def initialize(
      #   state_default : State? = nil,
      #   history_size : Abstract::HistorySize? = nil,
      #   state : State? = nil,
      #   history : Smcr::Sm::History? = nil,
      #   paths_allowed : Abstract::PathsAllowed? = nil
      # )
      #   @history_size = history_size ? history_size : Abstract::HistorySize.new(10)
  
      #   @state_default = state_default ? state_default : State.values.first
      #   @state = state ? state : @state_default
  
      #   @history = history ? history : Smcr::Sm::History.new
      #   @paths_allowed = paths_allowed ? paths_allowed : Abstract::PathsAllowed.new # initial_default_path
      #   init_paths
  
      #   @errors = Abstract::CurrentErrors.new
      #   validate
      # end


      def init_history
        Smcr::Sm::History.new
      end
  
      # def validate
      #   @errors.clear
  
      #   if @paths_allowed.keys.empty? || @paths_allowed.values.map(&.empty?).all?
      #     @errors[ERROR_KEY_PATHS_ALLOWED] = "must be an mapping of state to array of states"
      #   end
  
      #   @errors
      # end
  
      # def valid?
      #   @errors.empty?
      # end
  
      # # PATHS
  
      # def paths_allowed?(state_from, state_to)
      #   @paths_allowed.keys.includes?(state_from.value) && @paths_allowed[state_from.value].includes?(state_to.value)
      # end
  
      # def init_paths
      #   self.class.state_values.each do |state_from|
      #     init_paths_from(state_from)
      #   end
      # end
  
      # def init_paths_from(state_from)
      #   @paths_allowed[state_from.value] = Abstract::StatesAllowed.new
      # end
  
      # def reset_paths
      #   self.class.state_values.each do |state_from|
      #     @paths_allowed[state_from.value].clear
      #   end
      # end
  
      # def add_path(state_from, state_to)
      #   # init_paths_from(state_from) unless @paths_allowed.keys.includes?(state_from.value)
  
      #   # You can effectively re-order 'state_to' values by re-add a 'state_to' value (which gets moved to the end).
      #   remove_path(state_from, state_to)
  
      #   @paths_allowed[state_from.value] << state_to.value
      # end
  
      # def remove_path(state_from, state_to)
      #   @paths_allowed[state_from.value].delete(state_to.value) if @paths_allowed[state_from.value].includes?(state_to.value)
      # end
  
      # # ATTEMPT STATE CHANGE
      def attempt_state_change(try_state : State, resync : Bool = false, forced : Bool = false)
        attempt_pre = {
          resync: resync,
          forced: forced,
          from_state_value: state.value,
          try_state_value:  try_state.value,
          # callback_response: response,
        }
  
        attempt = case
                  when resync
                    # Resync was requested
                    attempt_pre.merge(callback_response: resync_state_change(attempt_pre))
                  when forced || paths_allowed[state].includes?(try_state)
                    # Forced state change requested OR state change is allowed.
                    attempt_pre.merge(callback_response: follow_attempted_state_change(attempt_pre))
                  else
                    # No resync nor forced requested and state requested is not allowed.
                    attempt_pre.merge(callback_response: ignore_attempted_state_change(attempt_pre))
                  end
  
        state_value = attempt[:callback_response][:to][:state_value]
        @state = State.from_value(state_value)
        append_history(attempt)
      end
  
      def resync_state_change(attempt_pre)
        # TODO Sub-class might need to handle resync's differently!
        # e.g.: Do some API call to get current state values and possibly some other data.
  
        # For now, we'll ignore the attempted state:
        to_state_value = state_machine.state.value
        {
          succeeded: false,
          to_state_value: to_state_value,
          code:      307, # e.g.: maybe mimic HTTP codes,
          message:   "Resyncing!",
        }
      end
  
      def follow_attempted_state_change(attempt_pre)
        callbacks_for(
          forced: attempt_pre[:forced],
          try_state: attempt_pre[:try][:state]
        )
      end
  
      def ignore_attempted_state_change(attempt_pre)
        # e.g.: Player A and Player B both try to move to tile X, but only one can at a time, so one request gets ignored.
        to_state_value = state_machine.state.value
  
        {
          succeeded: false,
          to_state_value: to_state_value.value,
          code:      307, # e.g.: maybe mimic HTTP codes,
          message:   "Ignoring attempted state change (state: #{attempt_pre[:try][:state]}).",
        }
      end
  
      # def append_history(attempt)
      #   @history << attempt
      #   @history = @history[-@history_size..-1] if @history.size > @history_size
      # end
  
      # # Modify these methods in sub-classes:
  
      def callbacks_for(
        forced : Bool,
        from_state : State, 
        try_state : State
      ) : CallbackResponse
        # Put callbacks in here via monkeypatch or sub-class.
        # Must return data with the following keys (hard-code values for now, but adjust as applicable):
        {
          succeeded: true,
          to_state_value: try_state.value,
          code:      200, # e.g.: maybe mimic HTTP codes,
          message:   "",
        }
      end
    end
  end  
end
