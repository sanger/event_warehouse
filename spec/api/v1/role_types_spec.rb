# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'v1/role_types', type: :request do
  let(:role_type1) { create(:role_type) }
  let(:role_type2) { create(:role_type) }

  before do
    role_type1
    role_type2
  end

  describe '#index' do
    it 'lists role_types' do
      get '/api/v1/role_types'
      expect(json_ids(true)).to eq([role_type1.id, role_type2.id])
      assert_payload(:role_type, role_type1, json_items[0])
    end
  end

  describe '#show' do
    it 'returns relevant role_type' do
      get "/api/v1/role_types/#{role_type1.id}"
      assert_payload(:role_type, role_type1, json_item)
    end
  end
end
