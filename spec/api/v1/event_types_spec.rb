# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventTypesController
  let!(:event_type1) { create(:event_type) }
  let!(:event_type2) { create(:event_type) }

  describe '#index' do
    it 'lists event_types' do
      get '/api/v1/event_types'
      expect(json_ids(true)).to eq([event_type1.id, event_type2.id])
      assert_payload(:event_type, event_type1, json_items[0])
    end

    context 'when sideloading events' do
      let!(:event1)  { create(:event, event_type: event_type1) }
      let!(:event2)  { create(:event, event_type: event_type1) }
      let!(:event3)  { create(:event, event_type: event_type2) }

      it 'returns relevant events in response' do # rubocop:todo RSpec/ExampleLength
        get '/api/v1/event_types', params: { include: 'events' }
        json_events = json_includes('events')
        expect(json_events.length).to eq(3)
        assert_payload(:event, event1, json_events[0])
        assert_payload(:event, event2, json_events[1])
        assert_payload(:event, event3, json_events[2])
      end
    end
  end

  describe '#show' do
    it 'returns relevant event_type' do
      get "/api/v1/event_types/#{event_type1.id}"
      assert_payload(:event_type, event_type1, json_item)
    end

    context 'when sideloading events' do
      let!(:event1)  { create(:event, event_type: event_type1) }
      let!(:event2)  { create(:event, event_type: event_type1) }

      before { create(:event, event_type: event_type2) }

      it 'returns relevant events in response' do # rubocop:todo RSpec/ExampleLength
        get "/api/v1/event_types/#{event_type1.id}", params: {
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
