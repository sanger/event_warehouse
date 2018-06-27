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
  end

  describe '#show' do
    it 'returns relevant subject' do
      get "/api/v1/subjects/#{subject1.id}"
      assert_payload(:subject, subject1, json_item)
    end
  end
end
