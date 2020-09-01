# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'v1/subject_types', type: :request do
  let!(:subject_type1) { create(:subject_type) }
  let!(:subject_type2) { create(:subject_type) }

  describe '#index' do
    it 'lists subject_types' do
      get '/api/v1/subject_types'
      expect(json_ids(true)).to eq([subject_type1.id, subject_type2.id])
      assert_payload(:subject_type, subject_type1, json_items[0])
    end

    context 'when sideloading subjects' do
      let!(:subject1)  { create(:subject, subject_type: subject_type1) }
      let!(:subject2)  { create(:subject, subject_type: subject_type1) }
      let!(:subject3)  { create(:subject, subject_type: subject_type2) }

      it 'returns relevant subjects in response' do
        get '/api/v1/subject_types', params: {
          include: 'subjects'
        }
        json_subjects = json_includes('subjects')
        expect(json_subjects.length).to eq(3)
        assert_payload(:subject, subject1, json_subjects[0])
        assert_payload(:subject, subject2, json_subjects[1])
        assert_payload(:subject, subject3, json_subjects[2])
      end
    end
  end

  describe '#show' do
    it 'returns relevant subject_type' do
      get "/api/v1/subject_types/#{subject_type1.id}"
      assert_payload(:subject_type, subject_type1, json_item)
    end

    context 'when sideloading subjects' do
      let!(:subject1)  { create(:subject, subject_type: subject_type1) }
      let!(:subject2)  { create(:subject, subject_type: subject_type1) }
      let!(:subject3)  { create(:subject, subject_type: subject_type2) }

      it 'returns relevant subjects in response' do
        get "/api/v1/subject_types/#{subject_type1.id}", params: {
          include: 'subjects'
        }
        json_subjects = json_includes('subjects')
        expect(json_subjects.length).to eq(2)
        assert_payload(:subject, subject1, json_subjects[0])
        assert_payload(:subject, subject2, json_subjects[1])
      end
    end
  end
end
