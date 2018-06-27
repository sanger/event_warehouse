# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'v1/roles', type: :request do
  let(:role1) { create(:role) }
  let(:role2) { create(:role) }

  before do
    role1
    role2
  end

  describe '#index' do
    it 'lists roles' do
      get '/api/v1/roles'
      expect(json_ids(true)).to eq([role1.id, role2.id])
      assert_payload(:role, role1, json_items[0])
    end
  end

  describe '#show' do
    it 'returns relevant role' do
      get "/api/v1/roles/#{role1.id}"
      assert_payload(:role, role1, json_item)
    end
  end
end
