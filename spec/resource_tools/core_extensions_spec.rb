# frozen_string_literal: true

require 'spec_helper'

describe ResourceTools::CoreExtensions do
  describe NilClass do
    context '#latest' do
      let(:callback) do
        double(:callback).tap do |callback|
          expect(callback).to receive(:call).with(nil)
        end
      end

      it 'yields value' do
        nil.latest('value', &callback.method(:call))
      end

      it 'should remain unchanged' do
        expect(nil.to_boolean_from_arguments).to be nil
      end
    end
  end

  describe Hash do
    subject { { a: 1, b: 2 } }

    context '#reverse_slice' do
      it 'returns a hash without the specified keys' do
        expect(subject.reverse_slice(:b)).to eq(a: 1)
      end

      it 'does not affect the original hash' do
        subject.reverse_slice(:b)
        expect(subject).to eq(a: 1, b: 2)
      end
    end
  end

  describe TrueClass do
    subject { true }

    it 'should remain unchanged' do
      expect(subject.to_boolean_from_arguments).to be true
    end
  end

  describe FalseClass do
    subject { false }

    it 'should remain unchanged' do
      expect(subject.to_boolean_from_arguments).to be false
    end
  end

  describe String do
    context '#to_boolean_from_arguments' do
      context 'when it is Yes' do
        subject { 'Yes' }
        it 'returns true' do
          expect(subject.to_boolean_from_arguments).to be true
        end
      end
      context 'when it is No' do
        subject { 'No' }
        it 'returns false' do
          expect(subject.to_boolean_from_arguments).to be false
        end
      end
      context 'when it is unknown' do
        subject { 'Unknown' }
        it 'raises an exception' do
          expect { subject.to_boolean_from_arguments }
            .to raise_error RuntimeError, 'Cannot convert "Unknown" to a boolean safely!'
        end
      end
    end
  end


  describe Array do
    context '#convert' do
      it 'converts a single hash to an array of 1' do
        expect(::Array.convert(example: 'example')).to eq([{ example: 'example' }])
      end

      it 'does not modify an array of hashes' do
        expect(::Array.convert([{ example: 'example' }, { example: 'example' }]))
          .to eq([{ example: 'example' }, { example: 'example' }])
      end
    end
  end
end
