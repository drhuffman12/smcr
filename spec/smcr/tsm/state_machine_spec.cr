require "./../../spec_helper"

class LightTickStateMachine < Smcr::Tsm::StateMachine(LightColors)

  # def callbacks_for(
  #   forced : Bool,
  #   # from_tick : Smcr::Tsm::Tick, from_state : State,
  #   try_tick : Smcr::Tsm::Tick, try_state : State
  # ) : CallbackResponse
  #   # Put callbacks in here via monkeypatch or sub-class

  #   # Must return data with the following keys (hard-code values for now):
  #   {
  #     succeeded: true,
  #     to:        {tick: try_tick, state_value: try_state.value},
  #     code:      200, # e.g.: maybe mimic HTTP codes,
  #     message:   "",
  #   }
  # end
end

Spectator.describe Smcr::Tsm::StateMachine do
  context "example off, red, green, blue" do
    let(state_class_expected) { LightColors }

    let(state_names_expected) { ["Off", "Red", "Green", "Blue"] }
    let(state_values_expected) { [LightColors::Off, LightColors::Red, LightColors::Green, LightColors::Blue] }
    let(state_internal_values_expected) { [0, 1, 2, 3] }

    let(state_default) { LightColors::Off }
    let(history_size) { 2.to_u8 }
    let(tick) { 0 }
    let(state) { LightColors::Blue }
    let(history) { nil }
    let(paths_allowed) { nil }

    let(state_machine) {
      LightTickStateMachine.new(
        state_default: state_default,
        history_size: history_size,
        # tick: tick,
        state: state,
        # history: history,
        paths_allowed: paths_allowed
      )
    }

    let(state_default_expected) { state_default }
    let(history_size_expected) { history_size }
    let(tick_expected) { tick }
    let(state_expected) { state }
    let(history_expected) { Smcr::Abstract::History.new }

    let(paths_allowed_initially_expected) {
      {
        LightColors::Off.value   => Smcr::Abstract::StatesAllowed.new,
        LightColors::Red.value   => Smcr::Abstract::StatesAllowed.new,
        LightColors::Green.value => Smcr::Abstract::StatesAllowed.new,
        LightColors::Blue.value  => Smcr::Abstract::StatesAllowed.new,
      }
    }

    let(errors_expected) {
      {"paths_allowed_missing" => "must be an mapping of state to array of states"}
    }

    describe ".state_class" do
      # TODO
    end

    describe ".state_names" do
      # TODO
    end

    describe ".state_values" do
      # TODO
    end

    describe ".state_internal_values" do
      # TODO
    end

    # describe "to/from/to json" do
    #   let(to_json) { state_machine.to_json }
    #   let(from_json) { LightTickStateMachine.from_json(to_json) }
    #   let(to_json2) { from_json.to_json }

    #   # For now, just a simple check to make sure to/from JSON doesn't error!
    #   # We probably should check various keys and values individually.
    #   it "JSON values match" do
    #     expect(to_json).to eq(to_json2)
    #   end
    # end
    describe "to/from/to json" do
      let(to_json) { state_machine.validate; state_machine.to_json }

      # For now, just a simple check to make sure to/from JSON doesn't error!
      # We probably should check various keys and values individually.
      context "when NO allowed_paths defined (as is the case with the basic state machines defined)" do
        it "it raises" do
          expect {
            LightTickStateMachine.from_json(to_json)
          }.to raise_error(Smcr::Abstract::InvalidStateMachine)
        end
      end

      context "when some allowed_paths defined" do
        let(from_json) { LightTickStateMachine.from_json(to_json) }
        let(to_json2) { from_json.to_json }

        before_each do
          state_machine.link_states
        end

        it "JSON values match" do
          expect(to_json).to eq(to_json2)
        end
      end
    end

    describe "#initialize" do
      context "sets values for" do
        it ".state_class" do
          expect(state_machine.class.state_class).to eq(state_class_expected)
        end

        it ".state_names" do
          expect(state_machine.class.state_names).to eq(state_names_expected)
        end

        it ".state_values" do
          expect(state_machine.class.state_values).to eq(state_values_expected)
        end

        it ".state_internal_values" do
          expect(state_machine.class.state_internal_values).to eq(state_internal_values_expected)
        end

        it "state_default" do
          expect(state_machine.state_default).to eq(state_default_expected)
        end

        it "history_size" do
          expect(state_machine.history_size).to eq(history_size_expected)
        end

        it "tick" do
          expect(state_machine.tick).to eq(tick_expected)
        end

        it "state" do
          expect(state_machine.state).to eq(state_expected)
        end

        it "history" do
          expect(state_machine.history).to eq(history_expected)
        end

        it "paths_allowed_missing" do
          expect(state_machine.paths_allowed).to eq(paths_allowed_initially_expected)
        end

        it "errors" do
          expect(state_machine.errors).to eq(errors_expected)
        end
      end
    end

    describe "#validate" do
      # TODO
    end

    describe "#valid?" do
      # TODO
    end

    describe "#paths_allowed?" do
      # TODO
    end

    describe "#init_paths" do
      # TODO
    end

    describe "#init_paths_from" do
      # TODO
    end

    describe "#add_path" do
      let(state_from) { LightColors.values.sample }
      let(state_to) { LightColors.values.sample }
      let(paths_allowed_updated_expected) {
        paths_allowed_initially_expected.clone.tap { |paths|
          paths[state_from.value] << state_to.value
        }
      }

      it "connects given states" do
        if Smcr::DEBUG_ENABLED
          puts
          puts "Before:"
          p! state_machine.paths_allowed
          puts
        end

        expect(state_machine.paths_allowed).to eq(paths_allowed_initially_expected)
        state_machine.add_path(state_from, state_to)
        expect(state_machine.paths_allowed).not_to eq(paths_allowed_initially_expected)
        expect(state_machine.paths_allowed).to eq(paths_allowed_updated_expected)

        if Smcr::DEBUG_ENABLED
          puts
          puts "After:"
          p! state_machine.paths_allowed
          puts
        end
      end

      context "reordering of connections" do
        let(state_from) { LightColors::Off }
        let(state_to_1) { LightColors::Red }
        let(state_to_2) { LightColors::Green }
        let(paths_allowed_updated_expected_1) {
          paths_allowed_initially_expected.clone.tap { |paths|
            paths[state_from.value] = [state_to_1.value, state_to_2.value]
          }
        }
        let(paths_allowed_updated_expected_2) {
          paths_allowed_initially_expected.clone.tap { |paths|
            paths[state_from.value] = [state_to_2.value, state_to_1.value]
          }
        }

        context "when connecting from 'Off' to 'Red' followed by 'Green'" do
          it "has expected paths_allowed" do
            state_machine.add_path(state_from, state_to_1)
            state_machine.add_path(state_from, state_to_2)
            expect(state_machine.paths_allowed).to eq(paths_allowed_updated_expected_1)

            if Smcr::DEBUG_ENABLED
              puts
              puts "After:"
              p! state_machine.paths_allowed
              puts
            end
          end

          context "followed by connecting 'Off' to 'Red' (a second time)" do
            it "moves the 'Off'-'Red' connection to the end" do
              state_machine.add_path(state_from, state_to_1)
              state_machine.add_path(state_from, state_to_2)
              state_machine.add_path(state_from, state_to_1)
              expect(state_machine.paths_allowed).to eq(paths_allowed_updated_expected_2)

              if Smcr::DEBUG_ENABLED
                puts
                puts "After:"
                p! state_machine.paths_allowed
                puts
              end
            end
          end
        end
      end
    end

    describe "#remove_path" do
      let(state_from) { LightColors::Off }
      let(state_to_1) { LightColors::Red }
      let(paths_allowed_updated_expected_1) {
        paths_allowed_initially_expected.clone.tap { |paths|
          paths[state_from.value] = [state_to_1.value]
        }
      }
      let(paths_allowed_updated_expected_2) {
        paths_allowed_initially_expected.clone.tap { |paths|
          paths[state_from.value] = Smcr::Abstract::StatesAllowed.new
        }
      }
      context "when connecting from 'Off' to 'Red' followed by removing that connection" do
        it "forgets the connection from 'Off' to 'Red'" do
          state_machine.add_path(state_from, state_to_1)
          expect(state_machine.paths_allowed).to eq(paths_allowed_updated_expected_1)
          state_machine.remove_path(state_from, state_to_1)
          expect(state_machine.paths_allowed).to eq(paths_allowed_updated_expected_2)
        end
      end
    end

    # describe "#attempt_state_change" do
    #   let(tick) { 1 }
    #   let(state) { LightColors::Blue }
    #   let(try_tick) { 2 }
    #   let(try_state) { LightColors::Red }
    #   # let(try_state) { LightColors.values.sample }
    #   # let(try_state) { state_machine.other_state_values.sample }

    #   context "tries to move to a different" do
    #     it "tick" do
    #       expect(state_machine.tick).not_to eq(try_tick)
    #     end

    #     it "state" do
    #       expect(state_machine.state).not_to eq(try_state)
    #     end
    #   end

    #   context "when not forced" do
    #     let(forced) { false }
    #     # let(tick_before) { state_machine.tick.clone }
    #     # let(state_before) { state_machine.state.clone }
    #     # let(attempt_details) {
    #     #   state_machine.attempt_state_change(
    #     #     forced: forced,
    #     #     try_tick: try_tick, try_state: try_state
    #     #   )
    #     # }

    #     # it "does not raise" do
    #     #   expect{
    #     #     response = state_machine.attempt_state_change(
    #     #       forced: forced,
    #     #       try_tick: try_tick, try_state: try_state
    #     #     )
    #     #     expect(response).to eq(attempt_entry_expected)
    #     #   }.not_to raise_exception
    #     # end

    #     context "when succeeded" do
    #       let(to_tick) { 2 }
    #       let(to_state) { LightColors::Red }
    #       # let(to_state) { LightColors::Blue }

    #       let(callback_response_expected) {
    #         {
    #           succeeded: true,
    #           to:        {tick: try_tick, state_value: try_state.value},
    #           code:      200, # e.g.: maybe mimic HTTP codes,
    #           message:   "",
    #         }
    #       }
    #       let(attempt_entry_expected) {
    #         {
    #           forced: forced,
    #           from:   {tick: state_machine.tick, state_value: state_machine.state.value},
    #           try:    {tick: try_tick, state_value: try_state.value},
    #           callback_response: callback_response_expected,
    #         }
    #       }
    #       # before_each do
    #       #   allow(state_machine).to receive(:callbacks_for).with(
    #       #     forced: forced,
    #       #     try_tick: try_tick, try_state: try_state
    #       #   ).and_return(attempt_entry_expected)

    #       #   # state_machine
    #       # end

    #       # context "it calls" do
    #       #   it "callbacks_for" do
    #       #     expect(state_machine).to receive(:callbacks_for).with(
    #       #       forced: forced,
    #       #       try_tick: try_tick, try_state: try_state
    #       #     ).and_return(attempt_entry_expected)

    #       #     state_machine.attempt_state_change(
    #       #       forced: forced,
    #       #       try_tick: try_tick, try_state: try_state
    #       #     )
    #       #   end
    #       # end

    #       context "moves to tried" do
    #         it "tick" do
    #           expect(state_machine.tick).not_to eq(try_tick)

    #           state_machine.attempt_state_change(
    #             forced: forced,
    #             try_tick: try_tick, try_state: try_state
    #           )

    #           expect(state_machine.tick).to eq(to_tick)
    #         end

    #         it "state" do
    #           expect(state_machine.state).not_to eq(try_state)

    #           state_machine.attempt_state_change(
    #             forced: forced,
    #             try_tick: try_tick, try_state: try_state
    #           )

    #           expect(state_machine.state).to eq(to_state)
    #         end
    #       end

    #       it "appends the 'attempt_details' to '@history'" do
    #         history_before = state_machine.history.clone

    #         puts
    #         p! state_machine.paths_allowed
    #         p! state_machine.tick
    #         p! state_machine.state

    #         p! try_tick
    #         p! try_state

    #         response = state_machine.attempt_state_change(
    #           forced: forced,
    #           try_tick: try_tick, try_state: try_state
    #         )

    #         p! response
    #         p! state_machine.tick
    #         p! state_machine.state
    #         p! state_machine.errors

    #         puts

    #         expect(state_machine.history.size).to eq(history_before.size + 1)
    #         expect(state_machine.history.last).to eq(response)
    #       end

    #       it "returns attempt_details entry expected" do
    #         response = state_machine.attempt_state_change(
    #           forced: forced,
    #           try_tick: try_tick, try_state: try_state
    #         )
    #         expect(response).to eq(attempt_entry_expected)
    #       end
    #     end

    #     context "when failed" do
    #       let(to_tick) { 2 }
    #       let(to_state) { LightColors::Blue }

    #       let(callback_response_expected) {
    #         {
    #           succeeded: false,
    #           to:        {tick: state_machine.tick, state_value: state_machine.state.value},
    #           code:      500, # e.g.: maybe mimic HTTP codes,
    #           message:   "",
    #         }
    #       }
    #       let(attempt_entry_expected) {
    #         {
    #           forced: forced,
    #           from:   {tick: state_machine.tick, state_value: state_machine.state.value},
    #           try:    {tick: try_tick, state_value: try_state.value},
    #           callback_response: callback_response_expected,
    #         }
    #       }

    #       before_each do
    #         # In this case, a state change failure prevents a move.
    #         allow(state_machine).to receive(:callbacks_for).with(
    #           forced: forced,
    #           try_tick: try_tick, try_state: try_state
    #         ).and_return(callback_response_expected)
    #       end

    #       # it "calls '#callbacks_for'" do
    #       #   expect(state_machine).to receive(:callbacks_for).with(
    #       #     forced: forced,
    #       #     try_tick: try_tick, try_state: try_state
    #       #   ).and_return(callback_response_expected)

    #       #   state_machine.attempt_state_change(
    #       #     forced: forced,
    #       #     try_tick: try_tick, try_state: try_state
    #       #   )
    #       # end

    #       context "does NOT move to tried" do
    #         it "tick" do
    #           ticket_before = state_machine.tick.clone
    #           expect(state_machine.tick).not_to eq(try_tick)

    #           state_machine.attempt_state_change(
    #             forced: forced,
    #             try_tick: try_tick, try_state: try_state
    #           )

    #           expect(state_machine.tick).to eq(ticket_before)
    #         end

    #         it "state" do
    #           state_before = state_machine.state.clone
    #           expect(state_machine.state).not_to eq(try_state)

    #           state_machine.attempt_state_change(
    #             forced: forced,
    #             try_tick: try_tick, try_state: try_state
    #           )

    #           expect(state_machine.state).to eq(state_before)
    #         end
    #       end

    #       it "appends the 'attempt_details' to '@history'" do
    #         history_before = state_machine.history.clone

    #         puts
    #         p! state_machine.paths_allowed
    #         p! state_machine.tick
    #         p! state_machine.state

    #         p! try_tick
    #         p! try_state

    #         response = state_machine.attempt_state_change(
    #           forced: forced,
    #           try_tick: try_tick, try_state: try_state
    #         )

    #         p! response
    #         p! state_machine.tick
    #         p! state_machine.state
    #         p! state_machine.errors

    #         puts

    #         expect(state_machine.history.size).to eq(history_before.size + 1)
    #         expect(state_machine.history.last).to eq(response)
    #       end

    #       it "returns attempt_details entry expected" do
    #         response = state_machine.attempt_state_change(
    #           forced: forced,
    #           try_tick: try_tick, try_state: try_state
    #         )
    #         expect(response).to eq(attempt_entry_expected)
    #       end

    #       # let(tick_before) { state_machine.tick.clone }
    #       # let(state_before) { state_machine.state.clone }
    #     #   let(attempt_details) {
    #     #     state_machine.attempt_state_change(
    #     #       forced: forced,
    #     #       try_tick: try_tick, try_state: try_state
    #     #     )
    #     #   }
    #     #   let(callback_response_expected) {
    #     #     {
    #     #       succeeded: false,
    #     #       to:        {tick: tick, state_value: state.value},
    #     #       code:      500, # e.g.: maybe mimic HTTP codes,
    #     #       message:   ""
    #     #     }
    #     #   }

    #     #   before_each do
    #     #     # In this case, a state change failure prevents a move.
    #     #     allow(state_machine).to receive(:callbacks_for).with(
    #     #       forced: forced,
    #     #       try_tick: try_tick, try_state: try_state
    #     #     ).and_return(callback_response_expected)
    #     #   end

    #     #   context "returns the attempt_details in which the attemp has expected values for key" do
    #     #     it "forced" do
    #     #       expect(attempt_details[:forced]).to eq(false)
    #     #     end
    #     #     it "from" do
    #     #       expect(attempt_details[:from]).to eq({tick: tick_before, state_before: state.value})
    #     #     end
    #     #     it "try" do
    #     #       expect(attempt_details[:try]).to eq({tick: try_tick, state_before: try_state.value})
    #     #     end
    #     #     it "callback_response" do
    #     #       expect(attempt_details[:callback_response]).to eq(callback_response_expected)
    #     #     end
    #     #   end
    #     end
    #   end
    #   # TODO
    # end

    # describe "#callbacks_for" do
    #   let(try_tick) { tick + 1 }
    #   let(try_state) { state_machine.other_state_values.sample }
    #   let(callback_response_expected) {
    #     {
    #       succeeded: false,
    #       to:        {tick: state_machine.tick, state_value: state_machine.state.value},
    #       code:      500, # e.g.: maybe mimic HTTP codes,
    #       message:   ""
    #     }
    #   }
    #   # let(attempt_entry_expected) {
    #   #   {
    #   #     forced: forced,
    #   #     from:   {tick: tick, state_value: state.value},
    #   #     try:    {tick: try_tick, state_value: try_state.value},
    #   #     callback_response: callback_response_expected,
    #   #   }
    #   # }
    #   it "foo" do
    #     response = state_machine.callbacks_for(
    #       forced: forced,
    #       try_tick: try_tick, try_state: try_state
    #     )
    #     expect(response).to eq(callback_response_expected)
    #   end
    # end
  end
end
