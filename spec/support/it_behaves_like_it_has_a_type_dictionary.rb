# frozen_string_literal: true

RSpec.shared_examples_for 'it has a type dictionary' do
  let(:type_assn)  { :"#{described_class.name.underscore}_type" }
  let(:type_class) { "#{described_class.name}Type".constantize }
  let(:example)    { build(:"#{described_class.name.underscore}") }
  let(:key)        { 'example_key' }

  it 'has a type of the expected class' do
    expect(example.send(type_assn)).to be_instance_of(type_class)
  end

  context 'when setting the type' do
    before(:example) do
      expect(type_class).to receive(:for_key).with(key)
    end

    it 'finds the type from the provided key' do
      example.send(:"#{type_assn}=", key)
    end
  end
end
