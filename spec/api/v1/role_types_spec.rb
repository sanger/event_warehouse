# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'v1/role_types', type: :request do
  let!(:role_type1) { create(:role_type) }
  let!(:role_type2) { create(:role_type) }

  describe '#index' do
    it 'lists role_types' do
      get '/api/v1/role_types'
      expect(json_ids(true)).to eq([role_type1.id, role_type2.id])
      assert_payload(:role_type, role_type1, json_items[0])
    end

    context 'when sideloading roles' do
      let!(:role1)  { create(:role, role_type: role_type1) }
      let!(:role2)  { create(:role, role_type: role_type1) }
      let!(:role3)  { create(:role, role_type: role_type2) }

      it 'returns relevant roles in response' do
        get '/api/v1/role_types', params: {
          include: 'roles'
        }
        json_roles = json_includes('roles')
        expect(json_roles.length).to eq(3)
        assert_payload(:role, role1, json_roles[0])
        assert_payload(:role, role2, json_roles[1])
        assert_payload(:role, role3, json_roles[2])
      end
    end
  end

  describe '#show' do
    it 'returns relevant role_type' do
      get "/api/v1/role_types/#{role_type1.id}"
      assert_payload(:role_type, role_type1, json_item)
    end

    context 'when sideloading roles' do
      let!(:role1)  { create(:role, role_type: role_type1) }
      let!(:role2)  { create(:role, role_type: role_type1) }
      let!(:role3)  { create(:role, role_type: role_type2) }

      it 'returns relevant roles in response' do
        get "/api/v1/role_types/#{role_type1.id}", params: {
          include: 'roles'
        }
        json_roles = json_includes('roles')
        expect(json_roles.length).to eq(2)
        assert_payload(:role, role1, json_roles[0])
        assert_payload(:role, role2, json_roles[1])
      end
    end
  end
end
