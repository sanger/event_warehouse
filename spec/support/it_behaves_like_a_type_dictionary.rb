shared_examples_for 'a type dictionary' do
  let(:example_key) { 'example_key' }
  let(:type_lookup) { described_class.for_key(example_key) }

  shared_examples_for 'returns a matching element' do
    it 'returns an appropriate type' do
      expect(type_lookup).to be_instance_of(described_class)
      expect(type_lookup.key).to eq(example_key)
      expect(type_lookup.description).to eq(expected_description)
    end
  end

  shared_examples_for 'finds no element' do
    it 'returns nil instead' do
      expect(type_lookup).to be_nil
    end
  end

  context 'when pre-existing' do
    let(:expected_description) { 'a pre-registered-description' }

    before(:example) do
      create(described_class.name.underscore.to_sym, key: example_key, description: expected_description)
    end

    it_behaves_like 'returns a matching element'
  end

  context 'when not pre-existing' do
    let(:expected_description) { described_class.default_description }

    context 'and registration in not required' do
      before(:context) do
        described_class.preregistration_required false
      end

      it_behaves_like 'returns a matching element'
    end

    context 'and registration is required' do
      before(:context) do
        described_class.preregistration_required true
      end

      it_behaves_like 'finds no element'
    end
  end
end
