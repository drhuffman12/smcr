require "./../spec_helper"

# TODO: extract to a separate shard

Spectator.describe Smcr::StateMachine do
  context "example off, red, green, blue" do
    enum LightColors
      Off
      Red
      Green
      Blue
    end

    let(state_machine) {
      Smcr::StateMachine(LightColors).new
    }
    # let(state_class_expected) { LightColors }

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
      let(state_names_expected) { ["Off", "Red", "Green", "Blue"] }
      let(state_values_expected) { [LightColors::Off, LightColors::Red, LightColors::Green, LightColors::Blue] }
      let(state_internal_values_expected) { [0, 1, 2, 3] }

      let(state_default) { LightColors::Off }
      let(history_size) { 2.to_u8 }
      let(tick) { 3 }
      let(state) { LightColors::Blue }
      # let(history) { nil } # TODO!
      let(paths_allowed) { nil }

      let(state_default_expected) { state_default }
      let(history_size_expected) { history_size }
      let(tick_expected) { tick }
      let(state_expected) { state }
      let(history_expected) { Smcr::StateChangeHistory.new }

      let(paths_allowed_expected) {
        {
          LightColors::Off.value => [LightColors::Red.value, LightColors::Green.value, LightColors::Blue.value],
        }
      }

      let(errors_expected) { Smcr::CurrentErrors.new }

      let(state_machine) {
        Smcr::StateMachine.new(
          state_default: state_default,
          history_size: history_size,
          tick: tick,
          state: state,
          # history: history, # TODO!
          paths_allowed: paths_allowed
        )
      }

      context "sets values for" do
        # it ".state_class" do
        #   expect(state_machine.class.state_class).to eq(state_class_expected)
        # end

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

        # it "history" do # TODO!
        #   expect(state_machine.history).to eq(history_expected)
        # end

        it "paths_allowed" do
          expect(state_machine.paths_allowed).to eq(paths_allowed_expected)
        end

        it "errors" do
          expect(state_machine.errors).to eq(errors_expected)
        end
      end
    end
  end
end
