# frozen_string_literal: true

RSpec.shared_examples_for 'a type dictionary' do
  let(:example_key) { 'example_key' }
  let(:type_lookup) { described_class.for_key(example_key) }

  shared_examples_for 'returns a matching element' do
    it 'returns an appropriate type' do
      expect(type_lookup).to be_instance_of(described_class)
    end

    it 'has the expected properties' do
      expect(type_lookup).to have_attributes(
        key: example_key,
        description: expected_description
      )
    end
  end

  shared_examples_for 'finds no element' do
    it 'returns nil instead' do
      expect(type_lookup).to be_nil
    end
  end

  context 'when pre-existing' do
    let(:expected_description) { 'a pre-registered-description' }

    before do
      create(described_class.name.underscore.to_sym, key: example_key, description: expected_description)
    end

    it_behaves_like 'returns a matching element'
  end

  context 'when not pre-existing' do
    let(:expected_description) { described_class.default_description }

    context 'when registration in not required' do
      before do
        allow(described_class).to receive(:preregistration_required?).and_return(false)
      end

      it_behaves_like 'returns a matching element'
    end

    context 'when registration is required' do
      before do
        allow(described_class).to receive(:preregistration_required?).and_return(true)
      end

      it_behaves_like 'finds no element'
    end
  end
end
