# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'v1/roles' do
  let!(:role1) { create(:role) }
  let!(:role2) { create(:role) }

  describe '#index' do
    before { get '/api/v1/roles', params: params }

    context 'with no options' do
      let(:params) { {} }

      it 'lists roles' do
        expect(json_ids(true)).to eq([role1.id, role2.id])
        assert_payload(:role, role1, json_items[0])
      end
    end

    context 'when sideloading events' do
      let(:params) { { include: 'event' } }
      let(:event1) { role1.event }
      let(:event2) { role2.event }

      it 'returns relevant events in response' do
        json_events = json_includes('events')
        expect(json_events.length).to eq(2)
        assert_payload(:event, event1, json_events[0])
        assert_payload(:event, event2, json_events[1])
      end
    end

    context 'when sideloading subjects' do
      let(:subject1) { role1.subject }
      let(:subject2) { role2.subject }
      let(:params) { { include: 'subject' } }

      it 'returns relevant subjects in response' do
        json_subjects = json_includes('subjects')
        expect(json_subjects.length).to eq(2)
        assert_payload(:subject, subject1, json_subjects[0])
        assert_payload(:subject, subject2, json_subjects[1])
      end
    end

    context 'when sideloading role types' do
      let(:role_type1)  { role1.role_type }
      let(:role_type2)  { role2.role_type }
      let(:params) { { include: 'role_type' } }

      it 'returns relevant roles in response' do
        json_role_types = json_includes('role_types')
        expect(json_role_types.length).to eq(2)
        assert_payload(:role_type, role_type1, json_role_types[0])
        assert_payload(:role_type, role_type2, json_role_types[1])
      end
    end
  end

  describe '#show' do
    it 'returns relevant role' do
      get "/api/v1/roles/#{role1.id}"
      assert_payload(:role, role1, json_item)
    end

    context 'when sideloading events' do
      let(:event1) { role1.event }

      it 'returns relevant events in response' do # rubocop:todo RSpec/ExampleLength
        get "/api/v1/roles/#{role1.id}", params: {
          include: 'event'
        }
        json_events = json_includes('events')
        expect(json_events.length).to eq(1)
        assert_payload(:event, event1, json_events[0])
      end
    end

    context 'when sideloading subjects' do
      let(:subject1) { role1.subject }

      it 'returns relevant subjects in response' do # rubocop:todo RSpec/ExampleLength
        get "/api/v1/roles/#{role1.id}", params: {
          include: 'subject'
        }
        json_subjects = json_includes('subjects')
        expect(json_subjects.length).to eq(1)
        assert_payload(:subject, subject1, json_subjects[0])
      end
    end

    context 'when sideloading role types' do
      let(:role_type1)  { role1.role_type }
      let(:role_type2)  { role1.role_type }

      it 'returns relevant roles in response' do # rubocop:todo RSpec/ExampleLength
        get "/api/v1/roles/#{role1.id}", params: {
          include: 'role_type'
        }
        json_role_types = json_includes('role_types')
        expect(json_role_types.length).to eq(1)
        assert_payload(:role_type, role_type1, json_role_types[0])
      end
    end
  end
end
