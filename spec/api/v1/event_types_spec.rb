# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'v1/event_types', type: :request do
  let(:event_type1) { create(:event_type) }
  let(:event_type2) { create(:event_type) }

  before do
    event_type1
    event_type2
  end

  describe '#index' do
    it 'lists event_types' do
      get '/api/v1/event_types'
      expect(json_ids(true)).to eq([event_type1.id, event_type2.id])
      assert_payload(:event_type, event_type1, json_items[0])
    end
  end

  describe '#show' do
    it 'returns relevant event_type' do
      get "/api/v1/event_types/#{event_type1.id}"
      assert_payload(:event_type, event_type1, json_item)
    end
  end
end
