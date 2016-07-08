require 'rails_helper'
SKETCHES_PATH = Rails.root.join('spec', 'sketches')

RSpec.describe Solution, type: :model do
  it 'is valid with a source and status' do
    solution = FactoryGirl.build(:solution)
    expect(solution).to be_valid
  end

  it 'is invalid without a source' do
    solution = FactoryGirl.build(:solution, source: '')
    expect(solution).not_to be_valid
  end

  describe '#status (aasm column)' do
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
      it { is_expected.to transition_from(:build_failed).to(:pending).on_event(:request_judgement) }

    end

    context 'with style_failed state' do
      subject(:solution) { Solution.new(status: :style_failed) }

      it { is_expected.to have_state(:style_failed) }
      it { is_expected.to transition_from(:style_failed).to(:pending).on_event(:request_judgement) }
    end

    context 'with passed state' do
      subject(:solution) { Solution.new(status: :passed) }

      it { is_expected.to have_state(:passed) }
      it { is_expected.to transition_from(:passed).to(:pending).on_event(:request_judgement) }
    end
  end

  describe '#request_judgement! (aasm event)' do
    context 'with source that includes no build errors' do
      let(:program) { 'line(0, 0, 100, 100);' }
      let!(:solution) { FactoryGirl.create(:solution) }

      before do
        solution.request_judgement!
      end

      it 'transitions state to :passed' do
        expect(solution.reload.status).to eq('passed')
      end

      it 'can retry request_judgement!' do
        solution.reload.request_judgement!
        expect(solution.reload.status).to eq('passed')
      end
    end

    context 'with source that includes build errors' do
      let(:program) { 'line(0, 0, 100);' }
      let!(:solution) { FactoryGirl.create(:build_failed_solution) }

      before do
        solution.request_judgement!
      end

      it 'transitions state to :build_failed' do
        expect(solution.reload.status).to eq('build_failed')
      end

      it 'can retry request_judgement!' do
        solution.reload.request_judgement!
        expect(solution.reload.status).to eq('build_failed')
      end

      it 'can fix build faild' do
        fixed_source = 'line(0, 0, 100, 100);'

        solution.reload
        solution.source = fixed_source
        solution.request_judgement!

        solution.reload
        expect(solution.status).to eq('passed')
        expect(solution.source).to eq(fixed_source)
      end
    end

    context 'with source that includes style errors' do
      let!(:solution) { FactoryGirl.create(:style_failed_solution) }

      before do
        solution.request_judgement!
      end

      it 'transitions state to :style_failed' do
        expect(solution.reload.status).to eq('style_failed')
      end

      it 'can retry request_judgement!' do
        solution.reload.request_judgement!
        expect(solution.reload.status).to eq('style_failed')
      end

      it 'can fix build faild' do
        fixed_source = 'line(0, 0, 100, 100);'

        solution.reload
        solution.source = fixed_source
        solution.request_judgement!

        solution.reload
        expect(solution.status).to eq('passed')
        expect(solution.source).to eq(fixed_source)
      end
    end
  end
end
