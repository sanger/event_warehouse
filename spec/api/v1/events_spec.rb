# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'v1/events', type: :request do
  let!(:event1) { create(:event, occured_at: Time.zone.now - 10.days) }
  let!(:event2) { create(:event, occured_at: Time.zone.now + 10.days) }

  describe '#index' do
    it 'lists events' do
      get '/api/v1/events'
      expect(json_ids(true)).to eq([event1.id, event2.id])
      assert_payload(:event, event1, json_items[0])
    end

    context 'when sideloading subjects' do
      let!(:subject1)  { create(:role, event: event1).subject }
      let!(:subject2)  { create(:role, event: event1).subject }
      let!(:subject3)  { create(:role, event: event2).subject }

      it 'returns relevant subjects in response' do
        get '/api/v1/events', params: {
          include: 'subjects'
        }
        json_subjects = json_includes('subjects')
        expect(json_subjects.length).to eq(3)
        assert_payload(:subject, subject1, json_subjects[0])
        assert_payload(:subject, subject2, json_subjects[1])
        assert_payload(:subject, subject3, json_subjects[2])
      end
    end

    context 'when sideloading roles' do
      let!(:role1)  { create(:role, event: event1) }
      let!(:role2)  { create(:role, event: event1) }
      let!(:role3)  { create(:role, event: event2) }

      it 'returns relevant roles in response' do
        get '/api/v1/events', params: {
          include: 'roles'
        }
        json_roles = json_includes('roles')
        expect(json_roles.length).to eq(3)
        assert_payload(:role, role1, json_roles[0])
        assert_payload(:role, role2, json_roles[1])
        assert_payload(:role, role3, json_roles[2])
      end
    end

    context 'when sideloading event types' do
      let!(:event_type1)  { event1.event_type }
      let!(:event_type2)  { event2.event_type }

      it 'returns relevant events in response' do
        get '/api/v1/events', params: {
          include: 'event_type'
        }
        json_event_types = json_includes('event_types')
        expect(json_event_types.length).to eq(2)
        assert_payload(:event_type, event_type1, json_event_types[0])
        assert_payload(:event_type, event_type2, json_event_types[1])
      end
    end

    describe 'filtering' do
      context 'before' do
        it 'filters correctly' do
          get '/api/v1/events', params: {
            filter: { occured_before: Time.zone.now.as_json }
          }
          expect(json_ids(true)).to match_array([event1.id])
        end
      end

      context 'after' do
        it 'filters correctly' do
          get '/api/v1/events', params: {
            filter: { occured_after: Time.zone.now.as_json }
          }
          expect(json_ids(true)).to match_array([event2.id])
        end
      end

      context 'by uuid' do
        it 'filters correctly' do
          get '/api/v1/events', params: {
            filter: { uuid: event1.uuid }
          }
          expect(json_ids(true)).to match_array([event1.id])
        end
      end
    end
  end

  describe '#show' do
    it 'returns relevant event' do
      get "/api/v1/events/#{event1.id}"
      assert_payload(:event, event1, json_item)
    end

    context 'when sideloading roles' do
      let!(:role1)  { create(:role, event: event1) }
      let!(:role2)  { create(:role, event: event1) }
      let!(:role3)  { create(:role, event: event2) }

      it 'returns relevant roles in response' do
        get "/api/v1/events/#{event1.id}", params: {
          include: 'roles'
        }
        json_roles = json_includes('roles')
        expect(json_roles.length).to eq(2)
        assert_payload(:role, role1, json_roles[0])
        assert_payload(:role, role2, json_roles[1])
      end
    end

    context 'when sideloading subjects' do
      let!(:subject1)  { create(:role, event: event1).subject }
      let!(:subject2)  { create(:role, event: event1).subject }
      let!(:subject3)  { create(:role, event: event2).subject }

      it 'returns relevant subjects in response' do
        get "/api/v1/events/#{event1.id}", params: {
          include: 'subjects'
        }
        json_subjects = json_includes('subjects')
        expect(json_subjects.length).to eq(2)
        assert_payload(:subject, subject1, json_subjects[0])
        assert_payload(:subject, subject2, json_subjects[1])
      end
    end

    context 'when sideloading event types' do
      let!(:event_type1)  { event1.event_type }
      let!(:event_type2)  { event1.event_type }

      it 'returns relevant events in response' do
        get "/api/v1/events/#{event1.id}", params: {
          include: 'event_type'
        }
        json_event_types = json_includes('event_types')
        expect(json_event_types.length).to eq(1)
        assert_payload(:event_type, event_type1, json_event_types[0])
      end
    end

    context 'fields' do
      it 'returns metadata' do
        get "/api/v1/events/#{event1.id}", params: {
          extra_fields: { events: 'metadata' }
        }
        assert_payload(:event_with_metadata, event1, json_item)
      end
    end
  end
end
