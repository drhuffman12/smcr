require "./../spec_helper"

# TODO: extract to a separate shard

Spectator.describe Smcr::StateMachine do
  describe "#initialize" do
    context "given no params" do
      let(state_machine) { Smcr::StateMachine.new }

      let(history_size_expected) { 10.to_u8 }
      let(states_allowed_expected) { [:off, :red, :green, :blue] }
      let(tick_expected) { 0 }
      let(state_expected) { :off }
      let(history_expected) { Smcr::StateChangeHistory.new }

      let(errors_expected) {
        {
          :states_allowed => "must be populated with states",
          :state_default  => "must be one of state_allowed",
          :states         => "must be one of state_allowed",
          :paths_allowed  => "must be an mapping of state to array of states",
        }
      }

      context "sets values for" do
        it "errors" do
          expect(state_machine.errors).to eq(errors_expected)
        end

        it "states_allowed" do
          expect(state_machine.states_allowed).to eq(states_allowed_expected)
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
      end
    end

    context "example off, red, green, blue" do
      let(states_allowed) { [:off, :red, :green, :blue] }
      let(history_size) { nil }
      let(tick) { nil }
      let(state) { nil }
      let(history) { nil }

      let(history_size_expected) { 10.to_u8 }
      let(states_allowed_expected) { [:off, :red, :green, :blue] }
      let(tick_expected) { 0 }
      let(state_expected) { :off }
      let(history_expected) { Smcr::StateChangeHistory.new }

      let(errors_expected) { Smcr::CurrentErrors.new }

      let(state_machine) {
        Smcr::StateMachine.new(
          states_allowed: states_allowed,
          tick: tick,
          state: state,
        )
      }

      context "sets values for" do
        it "errors" do
          expect(state_machine.errors).to eq(errors_expected)
        end

        it "states_allowed" do
          expect(state_machine.states_allowed).to eq(states_allowed_expected)
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
      end
    end
  end
end
