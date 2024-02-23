# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ResourceTools::Json::Handler' do
  let(:json_class) do
    Class.new(ResourceTools::Json::Handler) do
      translate('key' => 'translated')
    end
  end

  describe '::translate' do
    subject(:json) { json_class.new }

    it 'does not translate keys by default' do
      json['key'] = 'value'
      expect(json).to have_key('key')
    end

    it 'can translate keys' do
      json['key'] = 'value'
      expect(json).to have_key('translated')
    end

    it 'translates updated_at to last_updated' do
      json['updated_at'] = 'date'
      expect(json['last_updated']).to eq('date')
    end

    it 'translates created_at to created' do
      json['created_at'] = 'date'
      expect(json['created']).to eq('date')
    end
  end
end
