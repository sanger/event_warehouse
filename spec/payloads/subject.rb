# frozen_string_literal: true

JsonapiSpecHelpers::Payload.register(:subject) do
  key(:friendly_name, String, description: 'A user-readable "unique enough" identifier. Should mostly be unique.')
  key(:uuid, String, description: 'The UUID of the given subject. WILL bie unique.')
end
