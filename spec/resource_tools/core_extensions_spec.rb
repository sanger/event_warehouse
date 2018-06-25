# frozen_string_literal: true

require 'spec_helper'

describe ResourceTools::CoreExtensions do
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
