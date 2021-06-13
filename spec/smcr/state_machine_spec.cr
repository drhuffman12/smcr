require "./../spec_helper"

# TODO: extract to a separate shard

enum LightColors
  Off
  Red
  Green
  Blue
end

Spectator.describe Smcr::StateMachine do
  context "example off, red, green, blue" do
    let(state_class_expected) { LightColors }

    let(state_names_expected) { ["Off", "Red", "Green", "Blue"] }
    let(state_values_expected) { [LightColors::Off, LightColors::Red, LightColors::Green, LightColors::Blue] }
    let(state_internal_values_expected) { [0, 1, 2, 3] }

    let(state_default) { LightColors::Off }
    let(history_size) { 2.to_u8 }
    let(tick) { 3 }
    let(state) { LightColors::Blue }
    let(history) { nil }
    let(paths_allowed) { nil }

    let(state_machine) {
      Smcr::StateMachine.new(
        state_default: state_default,
        history_size: history_size,
        tick: tick,
        state: state,
        history: history,
        paths_allowed: paths_allowed
      )
    }

    let(state_default_expected) { state_default }
    let(history_size_expected) { history_size }
    let(tick_expected) { tick }
    let(state_expected) { state }
    let(history_expected) { Smcr::StateChangeHistory.new }

    let(paths_allowed_initially_expected) {
      {
        LightColors::Off.value   => Smcr::StatesAllowed.new,
        LightColors::Red.value   => Smcr::StatesAllowed.new,
        LightColors::Green.value => Smcr::StatesAllowed.new,
        LightColors::Blue.value  => Smcr::StatesAllowed.new,
      }
    }

    let(errors_expected) {
      {"paths_allowed" => "must be an mapping of state to array of states"}
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

    describe "to/from/to json" do
      let(to_json) { state_machine.to_json }
      let(from_json) { Smcr::StateMachine(LightColors).from_json(to_json) }
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

        it "tick" do
          expect(state_machine.tick).to eq(tick_expected)
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
          paths[state_from.value] = Smcr::StatesAllowed.new
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
