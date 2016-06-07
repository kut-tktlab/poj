require 'rails_helper'

RSpec.describe Solution, type: :model do
  it 'is valid with a source and status' do
    solution = FactoryGirl.build(:solution)
    expect(solution).to be_valid
  end

  it 'is invalid without a source' do
    solution = FactoryGirl.build(:solution, source: '')
    expect(solution).not_to be_valid
  end

  describe 'aasm column #status' do
    context 'with initial state' do
      subject(:solution) { Solution.new }

      it { is_expected.to have_state(:initial) }
      it { is_expected.to transition_from(:initial).to(:pending).on_event(:request_judgement) }
    end

    context 'with pending state' do
      subject(:solution) { Solution.new(status: :pending) }

      it { is_expected.to have_state(:pending) }
      it { is_expected.to transition_from(:pending).to(:judging).on_event(:judge) }
    end

    context 'with judging state' do
      subject(:solution) { Solution.new(status: :judging) }

      it { is_expected.to have_state(:judging) }
      it { is_expected.to transition_from(:judging).to(:build_failed).on_event(:fail_build) }
      it { is_expected.to transition_from(:judging).to(:passed).on_event(:pass) }
    end

    context 'with build_failed state' do
      subject(:solution) { Solution.new(status: :build_failed) }

      it { is_expected.to have_state(:build_failed) }
      it { is_expected.to transition_from(:build_failed).to(:initial).on_event(:reset) }
    end

    context 'with passed state' do
      subject(:solution) { Solution.new(status: :passed) }

      it { is_expected.to have_state(:passed) }
      it { is_expected.to transition_from(:passed).to(:initial).on_event(:reset) }
    end
  end
end
