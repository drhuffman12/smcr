require "./aliases.cr"

module Smcr
  module Abstract
    # Simple State Machine
    class InvalidStateMachine < Exception
    end

    abstract class StateMachine(State)
      include JSON::Serializable

      ERROR_PATHS_ALLOWED_MISSING      = "paths_allowed_missing"
      ERROR_PATHS_ALLOWED_FROM_INVALID = "paths_allowed_from_invalid"
      ERROR_PATHS_ALLOWED_TO_INVALID   = "paths_allowed_to_invalid"
      ERROR_KEY_RESYNC_NEEDED          = "error_key_resync_needed"
      ERROR_KEY_STATE_CHANGE_FAILED    = "history"

      getter state_default : State
      getter history_size : Abstract::HistorySize
      getter state : State
      getter history # : Smcr::Abstract::History
      getter paths_allowed : Abstract::PathsAllowed

      getter errors : Abstract::CurrentErrors

      def self.state_class
        State # Needed? Maybe just in case we want to programmatically remind our selves what the 'State' class is?
      end

      def self.state_names
        State.names # Needed?
      end

      def self.state_values
        State.values # Needed?
      end

      def state_other_values(not_counting_state : State = state)
        StateMachine(State).state_values - [not_counting_state] # Needed?
      end

      def self.state_internal_values
        State.values.map(&.value) # Needed?
      end

      def self.state_names_to_internal_values
        state_names.zip(state_internal_values).to_h
      end

      def other_state_internal_values
        StateMachine(State).state_internal_values - [state.value] # Needed?
      end

      def initialize(
        state_default : State? = nil,
        history_size : Smcr::Abstract::HistorySize? = nil,
        state : State? = nil,
        # history = nil, #  : Smcr::Abstract::History?
        paths_allowed : Smcr::Abstract::PathsAllowed? = nil
      )
        @history_size = history_size ? history_size : Abstract::HistorySize.new(10)

        @state_default = state_default ? state_default : State.values.first
        @state = state ? state : @state_default

        @history = init_history
        @paths_allowed = paths_allowed ? paths_allowed : Abstract::PathsAllowed.new # initial_default_path
        init_paths

        @errors = Abstract::CurrentErrors.new
        validate
      end

      def init_history
        # Adjust in sub-class!
        # Smcr::Abstract::History.new
      end

      def replace_history(prior_history)
        @history = prior_history
      end

      def self.from_json(string_or_io, root : String)
        sm = super
        sm.validate!
        sm
      end

      def self.from_json(string_or_io)
        sm = super
        sm.validate!
        sm
      end

      def validate!
        validate
        raise InvalidStateMachine.new(@errors.to_json) unless valid?
      end

      def validate
        @errors.clear

        # The 'add_path' and 'remove_path' methods should prevent the following.
        # But, when doing 'from_json', we might need to check validity.
        if @paths_allowed.keys.empty? || @paths_allowed.values.map(&.empty?).all?
          @errors[ERROR_PATHS_ALLOWED_MISSING] = "must be an mapping of state to array of states"
        end
        if !(@paths_allowed.keys - StateMachine(State).state_internal_values).empty?
          @errors[ERROR_PATHS_ALLOWED_FROM_INVALID] = "Each 'from' state internal value must be one of the valid state internal values"
        end
        if !(@paths_allowed.values.flatten.uniq! - StateMachine(State).state_internal_values).empty?
          @errors[ERROR_PATHS_ALLOWED_TO_INVALID] = "Each 'to' state internal values must be one of the valid state internal values"
        end

        @errors
      end

      def valid?
        @errors.empty?
      end

      # # PATHS

      def paths_allowed?(state_from, state_to)
        @paths_allowed.keys.includes?(state_from.value) && @paths_allowed[state_from.value].includes?(state_to.value)
      end

      def init_paths
        self.class.state_values.each do |state_from|
          init_paths_from(state_from)
        end
      end

      def init_paths_from(state_from)
        @paths_allowed[state_from.value] = Abstract::StatesAllowed.new
      end

      def reset_paths
        self.class.state_values.each do |state_from|
          @paths_allowed[state_from.value].clear
        end
      end

      def add_path(state_from, state_to)
        # You can effectively re-order 'state_to' values by re-add a 'state_to' value (which gets moved to the end).
        remove_path(state_from, state_to)

        @paths_allowed[state_from.value] << state_to.value
      end

      def remove_path(state_from, state_to)
        @paths_allowed[state_from.value].delete(state_to.value) if @paths_allowed[state_from.value].includes?(state_to.value)
      end

      def link_states
        self.class.state_values.each do |state_from|
          self.class.state_values.each do |state_to|
            add_path(state_from, state_to) unless state_from == state_to
          end
        end
      end

      # # # ATTEMPT STATE CHANGE
      # def attempt_state_change(try_state : State, resync : Bool = false, forced : Bool = false)
      #   attempt_pre = {
      #     resync: resync,
      #     forced: forced,
      #     from_state_value: state.value,
      #     try_state_value:  try_state.value,
      #   }

      #   attempt_details = case
      #             when resync
      #               # Resync was requested
      #               attempt_pre.merge(callback_response: resync_state_change(attempt_pre))
      #             when forced || paths_allowed[state].includes?(try_state)
      #               # Forced state change requested OR state change is allowed.
      #               attempt_pre.merge(callback_response: follow_attempted_state_change(attempt_pre))
      #             else
      #               # No resync nor forced requested and state requested is not allowed.
      #               attempt_pre.merge(callback_response: ignore_attempted_state_change(attempt_pre))
      #             end

      #   state_value = attempt_details[:callback_response][:to][:state_value]
      #   @state = State.from_value(state_value)
      #   append_history(attempt_details)
      # end

      # abstract def resync_state_change
      # def resync_state_change(attempt_pre)
      #   # TODO Sub-class might need to handle resync's differently!
      #   # e.g.: Do some API call to get current state values and possibly some other data.

      #   # For now, we'll ignore the attempted state:
      #   to_state_value = state_machine.state.value
      #   {
      #     succeeded: false,
      #     to_state_value: to_state_value,
      #     code:      307, # e.g.: maybe mimic HTTP codes,
      #     message:   "Resyncing!",
      #   }
      # end

      # abstract def follow_attempted_state_change
      # def follow_attempted_state_change(attempt_pre)
      #   callbacks_for(
      #     forced: attempt_pre[:forced],
      #     try_state: attempt_pre[:try][:state]
      #   )
      # end

      # abstract def ignore_attempted_state_change
      # def ignore_attempted_state_change(attempt_pre)
      #   # e.g.: Player A and Player B both try to move to tile X, but only one can at a time, so one request gets ignored.
      #   to_state_value = state_machine.state.value

      #   {
      #     succeeded: false,
      #     to_state_value: to_state_value.value,
      #     code:      307, # e.g.: maybe mimic HTTP codes,
      #     message:   "Ignoring attempted state change (state: #{attempt_pre[:try][:state]}).",
      #   }
      # end

      abstract def attempt_state_change(
        # forced : Bool,
        # from,
        attempting : Abstract::AttemptSummary,
        resync : Bool = false,
        forced : Bool = false
      ) : StateChangeAttempt

      def append_history(attempt_details)
        @history << attempt_details
        @history = @history[-@history_size..-1] if @history.size > @history_size
      end

      def follow_attempted_state_change(attempt_pre)
        callbacks_for(
          forced: attempt_pre[:forced],
          from: attempt_pre[:from],
          attempting: attempt_pre[:attempting]
        )
      end

      abstract def resync_state_change(attempt_pre) : CallbackResponse

      abstract def ignore_attempted_state_change(attempt_pre) : CallbackResponse

      # # Modify these methods in sub-classes:

      def callbacks_for(
        forced : Bool,
        from : Abstract::AttemptSummary,
        attempting : Abstract::AttemptSummary
      ) : Abstract::CallbackResponse
        # Put callbacks in here via monkeypatch or sub-class.
        # Must return data with the following keys (hard-code values for now, but adjust as applicable):
        {
          succeeded: true,
          to:        attempting,
          code:      200, # e.g.: maybe mimic HTTP codes,
          message:   "",
        }
      end
    end
  end
end
