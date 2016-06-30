require 'rails_helper'

SKETCHES_PATH = Rails.root.join('spec', 'sketches')

describe 'Processing::Sketch' do
  describe '.from_source' do
    let(:source) { 'line(0, 0, 100, 100);' }
    let(:instance) { Processing::Sketch.from_source(source) }

    it 'returns new instance of Processing::Sketch' do
      expect(instance).to be_a(Processing::Sketch)
    end

    it 'make temporary file for the source' do
      expect(instance.path).to include(Dir.tmpdir)
    end
  end

  describe '#build' do
    let(:sketch) { Processing::Sketch.new(sketch_path) }

    context 'with program that includes no build errors' do
      let(:sketch_path) { SKETCHES_PATH.join('BuildSucceeded').to_s }

      it 'returns nil' do
        expect(sketch.build).to be_nil
      end
    end

    context 'with program that includes build errors' do
      let(:sketch_path) { SKETCHES_PATH.join('BuildFailed').to_s }

      it 'returns a error message' do
        expect(sketch.build).to include('arguments')
      end
    end
  end

  describe '#check_style' do
    let(:sketch) { Processing::Sketch.new(sketch_path) }

    context 'with program that includes no build errors' do
      let(:sketch_path) { SKETCHES_PATH.join('BuildSucceeded').to_s }

      it 'returns nil' do
        expect(sketch.check_style).to be_nil
      end
    end

    context 'with program that includes build errors' do
      let(:sketch_path) { SKETCHES_PATH.join('CheckStyleFailed').to_s }

      it 'returns a error message' do
        expect(sketch.check_style).to include('COMMA')
      end
    end
  end

end
