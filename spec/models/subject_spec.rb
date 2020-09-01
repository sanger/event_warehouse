# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe Subject do
  let(:lookup) { described_class.lookup(uuid: uuid, friendly_name: new_friendly_name, subject_type: new_subject_type) }
  let(:old_subject_type)  { 'old_type' }
  let(:old_friendly_name) { 'old' }
  let(:new_subject_type)  { 'new_type' }
  let(:new_friendly_name) { 'new' }
  let(:uuid) { '00000000-1111-2222-3333-666666666666' }

  it_behaves_like 'it has a type dictionary'

  context 'when existing' do
    before do
      create(:subject, uuid: uuid, friendly_name: old_friendly_name, subject_type: old_subject_type)
    end

    it 'finds the existing record' do
      expect(lookup.uuid.to_s).to eq(uuid)
      expect(lookup.friendly_name).to eq(old_friendly_name)
      expect(lookup.subject_type.key).to eq(old_subject_type)
      expect(described_class.count).to eq(1)
    end
  end

  context 'when not existing' do
    it 'creates a new record' do
      expect(lookup.uuid.to_s).to eq(uuid)
      expect(lookup.friendly_name).to eq(new_friendly_name)
      expect(lookup.subject_type.key).to eq(new_subject_type)
      expect(described_class.count).to eq(1)
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
