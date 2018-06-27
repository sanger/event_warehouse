# frozen_string_literal: true

JsonapiSpecHelpers::Payload.register(:subject) do
  key(:friendly_name, String)
  key(:uuid, String)
end
