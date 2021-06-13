require "./../spec_helper"

# TODO: extract to a separate shard

Spectator.describe Smcr::StateMachine do
  context "given no params" do
    let(state_machine) { Smcr::StateMachine.new }

    let(states_allowed_expected) { Smcr::StatesAllowed.new }
    let(state_default_expected) { Smcr::StateMachine::STATE_NOT_SET }
    let(history_size_expected) { 10.to_u8 }
    let(tick_expected) { 0 }
    let(state_expected) { :state_not_set }
    let(history_expected) { Smcr::StateChangeHistory.new }
    let(paths_allowed_expected) { Smcr::PathsAllowed.new }

    let(errors_expected) {
      {
        :states_allowed => "must be populated with states",
        :state_default  => "must be one of state_allowed",
        :states         => "must be one of state_allowed",
        :paths_allowed  => "must be an mapping of state to array of states",
      }
    }

    describe "to/from/to json" do
      let(to_json) { state_machine.to_json }
      let(from_json) { Smcr::StateMachine.from_json(to_json) }
      let(to_json2) { from_json.to_json }

      # simple check
      it "JSON values match" do
        expect(to_json).to eq(to_json2)
      end

      # it "instance sizes match" do
      #   expect(state_machine).not_to be_nil
      #   # sm = Smcr::StateMachine.new
      #   state_machine_size = instance_sizeof(Smcr::StateMachine.new)
      #   from_json_size = instance_sizeof(from_json)
      #   expect(state_machine_size).to eq(from_json_size)
      # end
    end

    describe "#initialize" do
      context "sets values for" do
        it "states_allowed" do
          expect(state_machine.states_allowed).to eq(states_allowed_expected)
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
          expect(state_machine.paths_allowed).to eq(paths_allowed_expected)
        end

        it "errors" do
          expect(state_machine.errors).to eq(errors_expected)
        end
      end
    end
  end

  context "example off, red, green, blue" do
    describe "#initialize" do
      let(states_allowed) { [:off, :red, :green, :blue] }
      let(state_default) { :off }
      let(history_size) { 2.to_u8 }
      let(tick) { 3 }
      let(state) { :blue }
      let(history) { nil }
      let(paths_allowed) {
        {
          :off   => [:red, :green, :blue],
          :red   => [:off, :green, :blue],
          :green => [:off, :red, :blue],
          :blue  => [:off, :red, :green],
        }
      }

      let(states_allowed_expected) { states_allowed }
      let(state_default_expected) { state_default }
      let(history_size_expected) { history_size }
      let(tick_expected) { tick }
      let(state_expected) { state }
      let(history_expected) { Smcr::StateChangeHistory.new }

      let(paths_allowed_expected) {
        paths_allowed
      }

      let(errors_expected) { Smcr::CurrentErrors.new }

      let(state_machine) {
        Smcr::StateMachine.new(
          states_allowed: states_allowed,
          state_default: state_default,
          history_size: history_size,
          tick: tick,
          state: state,
          history: history,
          paths_allowed: paths_allowed
        )
      }

      context "sets values for" do
        it "states_allowed" do
          expect(state_machine.states_allowed).to eq(states_allowed_expected)
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
          expect(state_machine.paths_allowed).to eq(paths_allowed_expected)
        end

        it "errors" do
          expect(state_machine.errors).to eq(errors_expected)
        end
      end
    end
  end
end
