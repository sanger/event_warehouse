# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Metadatum do
  # Nothing to test. Its all incredibly simple, test coverage is provided by:
  # - The FactoryBot lint tests
  # - The event specs, which provide a degree of integration testing
  it 'can be created' do
    expect(described_class.new).to be_a(Metadatum)
  end
end
