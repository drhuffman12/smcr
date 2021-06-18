require "./../../spec_helper"

class LightStateMachine < Smcr::Sm::StateMachine(LightColors)

  # def callbacks_for(
  #   forced : Bool,
  #   # from_tick : Smcr::Sm::Tick, from_state : State,
  #   try_tick : Smcr::Sm::Tick, try_state : State
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

Spectator.describe Smcr::Sm::StateMachine do
  context "example off, red, green, blue" do
    let(state_class_expected) { LightColors }

    let(state_expected) { state }
    let(state_names_expected) { ["Off", "Red", "Green", "Blue"] }
    let(state_values_expected) { [LightColors::Off, LightColors::Red, LightColors::Green, LightColors::Blue] }
    let(state_other_values_expected) { [LightColors::Off, LightColors::Red, LightColors::Green] }
    let(state_internal_values_expected) { [0, 1, 2, 3] }

    let(state_default) { LightColors::Off }
    let(history_size) { 2.to_u8 }
    let(state) { LightColors::Blue }
    let(history) { nil }
    let(paths_allowed) { nil }

    let(state_machine) {
      LightStateMachine.new(
        state_default: state_default,
        history_size: history_size,
        state: state,
        # history: history,
        paths_allowed: paths_allowed
      )
    }

    let(state_default_expected) { state_default }
    let(history_size_expected) { history_size }
    let(state_expected) { state }
    let(history_expected) { Smcr::Sm::History.new }

    let(paths_allowed_initially_expected) {
      {
        LightColors::Off.value   => Smcr::Abstract::StatesAllowed.new,
        LightColors::Red.value   => Smcr::Abstract::StatesAllowed.new,
        LightColors::Green.value => Smcr::Abstract::StatesAllowed.new,
        LightColors::Blue.value  => Smcr::Abstract::StatesAllowed.new,
      }
    }

    let(errors_expected) {
      {"paths_allowed" => "must be an mapping of state to array of states"}
    }

    describe ".state_class" do
      it "returns the expected state class" do
        # expect(state_machine.class.state_class).to eq(state_class_expected)
        expect(state_machine.class.state_class).to eq(LightColors)
      end
    end

    describe ".state_names" do
      it "returns the expected state names" do
        expect(state_machine.class.state_names).to eq(state_names_expected)
        expect(state_machine.class.state_class.names).to eq(state_names_expected)
      end
    end

    describe ".state_values" do
      it "returns the expected state values" do
        expect(state_machine.class.state_values).to eq(state_values_expected)
      end
    end

    describe "#state_other_values" do
      it "returns the expected state values" do
        expect(state_machine.state).to eq(state_expected)
        expect(state_machine.state_other_values).to eq(state_other_values_expected)
      end
    end

    describe ".state_internal_values" do
      it "returns the expected state internal values" do
        expect(state_machine.class.state_internal_values).to eq(state_internal_values_expected)
      end
    end

    describe "to/from/to json" do
      let(to_json) { state_machine.to_json }
      let(from_json) { LightStateMachine.from_json(to_json) }
      let(to_json2) { from_json.to_json }

      # For now, just a simple check to make sure to/from JSON doesn't error!
      # We probably should check various keys and values individually.
      it "JSON values match" do
        expect(to_json).to eq(to_json2)
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

        it "state" do
          expect(state_machine.state).to eq(state_expected)
        end

        it "history" do
          expect(state_machine.history).to eq(history_expected)
        end

        it "paths_allowed" do
          expect(state_machine.paths_allowed).to eq(paths_allowed_initially_expected)
        end

        pending "calls 'validate'" do
          expect_any_instance_of(LightStateMachine).to receive(:validate)
          LightStateMachine.new(
            state_default: state_default,
            history_size: history_size,
            state: state,
            # history: history,
            paths_allowed: paths_allowed
          )
        end

        it "errors" do
          expect(state_machine.errors.keys.size).to eq(1)
          expect(state_machine.errors).to eq(errors_expected)
        end
      end
    end

    describe "#validate" do
      pending "inits a 'CurrentErrors'" do
        expect(state_machine.errors).to receive(:clear)
        state_machine.validate
      end

      it "errors" do
        expect(state_machine.errors.keys.size).to eq(1)
        expect(state_machine.errors).to eq(errors_expected)
      end
    end

    describe "#valid?" do
      context "when 'errors' has keys" do
        it "returns true" do
          expect(state_machine.errors.keys).not_to be_empty
          expect(state_machine.valid?).to be_false
        end
      end
      context "when 'errors' has NO keys (because a path was added)" do
        it "returns true" do
          expect(state_machine.errors.keys).not_to be_empty
          expect(state_machine.valid?).to be_false
          state_machine.add_path(state_machine.state, state_machine.state_default)
          state_machine.validate
          expect(state_machine.errors.keys).to be_empty
          expect(state_machine.valid?).to be_true
        end
      end
    end

    describe "#paths_allowed?" do
      context "before paths added" do
        context "there are NO allowed paths" do
          it "from the initial state" do
            state_values_expected.each do |state_to|
              expect(state_machine.paths_allowed?(state_machine.state, state_to)).to be_false
            end
          end
        end
      end
      context "after paths added" do
        let(state_to_red) { LightColors::Red }
        context "there are allowed path(s)" do
          it "from the current (i.e.: initial) state" do
            state_values_expected.each do |state_to|
              expect(state_machine.paths_allowed?(state_machine.state, state_to)).to be_false
            end

            state_machine.add_path(state_machine.state, state_to_red)

            puts
            p! state_machine.paths_allowed
            p! state_machine.state
            puts

            expect(state_machine.paths_allowed?(state_machine.state, LightColors::Off)).to be_false
            expect(state_machine.paths_allowed?(state_machine.state, LightColors::Red)).to be_true
            expect(state_machine.paths_allowed?(state_machine.state, LightColors::Green)).to be_false
            expect(state_machine.paths_allowed?(state_machine.state, LightColors::Blue)).to be_false
          end
        end
      end
    end

    describe "#init_paths" do
      before_each do
        state_values_expected.each do |state_from|
          state_values_expected.each do |state_to|
            state_machine.add_path(state_from, state_to) unless state_from == state_to
          end
        end
      end
      it "when paths were previously set" do
        puts
        puts "BEFORE"
        p! state_machine.paths_allowed
        p! state_machine.state
        puts

        expect(state_machine.paths_allowed.keys.size).to eq(4)
        expect(state_machine.paths_allowed.values.flatten.size).to eq(12)
      end
      context "when paths were previously set" do
        it "re-initializes the allowed paths" do
          state_machine.reset_paths

          puts
          puts "AFTER"
          p! state_machine.paths_allowed
          p! state_machine.state
          puts

          expect(state_machine.paths_allowed.keys.size).to eq(4)
          expect(state_machine.paths_allowed.values.flatten.size).to eq(0)
        end
      end
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
  end
end
