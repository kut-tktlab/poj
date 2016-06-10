require 'rails_helper'

SKETCHES_PATH = Rails.root.join('spec', 'sketches')

describe 'Processing' do
  describe '.build' do
    let(:program_path) { SKETCHES_PATH.join('BuildSucceeded') }

    context 'with program that includes no build errors' do
      it 'returns true' do
        expect(Processing.build(program_path.to_s)).to be_truthy
      end
    end

    context 'with program that includes build errors' do
      let(:program_path) { SKETCHES_PATH.join('BuildFailed') }

      it 'returns false' do
        expect(Processing.build(program_path.to_s)).to be_falsey
      end
    end
  end

  describe '.build_str' do
    let(:program) { 'line(0, 0, 100, 100);' }

    context 'with program that includes no build errors' do
      it 'returns true' do
        expect(Processing.build_str(program)).to be_truthy
      end
    end

    context 'with program that includes build errors' do
      let(:program) { 'line(0, 0, 100);' }

      it 'returns false' do
        expect(Processing.build_str(program)).to be_falsey
      end
    end
  end

end