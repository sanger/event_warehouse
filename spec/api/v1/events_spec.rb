# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'v1/events', type: :request do
  let(:event1) { create(:event) }
  let(:event2) { create(:event) }

  before do
    event1
    event2
  end

  describe '#index' do
    it 'lists events' do
      get '/api/v1/events'
      expect(json_ids(true)).to eq([event1.id, event2.id])
      assert_payload(:event, event1, json_items[0])
    end
  end

  describe '#show' do
    it 'returns relevant event' do
      get "/api/v1/events/#{event1.id}"
      assert_payload(:event, event1, json_item)
    end
  end
end
