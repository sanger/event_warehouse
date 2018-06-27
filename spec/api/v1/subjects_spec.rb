# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'v1/subjects', type: :request do
  let(:subject1) { create(:subject) }
  let(:subject2) { create(:subject) }

  before do
    subject1
    subject2
  end

  describe '#index' do
    it 'lists subjects' do
      get '/api/v1/subjects'
      expect(json_ids(true)).to eq([subject1.id, subject2.id])
      assert_payload(:subject, subject1, json_items[0])
    end
    context 'when sideloading subject types' do
      let!(:subject_type1)  { subject1.subject_type }
      let!(:subject_type2)  { subject2.subject_type }

      it 'returns relevant subjects in response' do
        get '/api/v1/subjects', params: {
          include: 'subject_type'
        }
        json_subject_types = json_includes('subject_types')
        expect(json_subject_types.length).to eq(2)
        assert_payload(:subject_type, subject_type1, json_subject_types[0])
        assert_payload(:subject_type, subject_type2, json_subject_types[1])
      end
    end
  end

  describe '#show' do
    it 'returns relevant subject' do
      get "/api/v1/subjects/#{subject1.id}"
      assert_payload(:subject, subject1, json_item)
    end

    context 'when sideloading subject types' do
      let!(:subject_type1)  { subject1.subject_type }
      let!(:subject_type2)  { subject2.subject_type }

      it 'returns relevant subjects in response' do
        get "/api/v1/subjects/#{subject1.id}", params: {
          include: 'subject_type'
        }
        json_subject_types = json_includes('subject_types')
        expect(json_subject_types.length).to eq(1)
        assert_payload(:subject_type, subject_type1, json_subject_types[0])
      end
    end

    context 'when sideloading roles' do
      let!(:role1)  { create(:role, subject: subject1) }
      let!(:role2)  { create(:role, subject: subject1) }
      let!(:role3)  { create(:role, subject: subject2) }

      it 'returns relevant roles in response' do
        get "/api/v1/subjects/#{subject1.id}", params: {
          include: 'roles'
        }
        json_roles = json_includes('roles')
        expect(json_roles.length).to eq(2)
        assert_payload(:role, role1, json_roles[0])
        assert_payload(:role, role2, json_roles[1])
      end
    end

    context 'when sideloading events' do
      let!(:event1)  { create(:role, subject: subject1).event }
      let!(:event2)  { create(:role, subject: subject1).event }
      let!(:event3)  { create(:role, subject: subject2).event }

      it 'returns relevant subjects in response' do
        get "/api/v1/subjects/#{subject1.id}", params: {
          include: 'events'
        }
        json_events = json_includes('events')
        expect(json_events.length).to eq(2)
        assert_payload(:event, event1, json_events[0])
        assert_payload(:event, event2, json_events[1])
      end
    end
  end
end
