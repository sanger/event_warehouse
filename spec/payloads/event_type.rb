# frozen_string_literal: true

JsonapiSpecHelpers::Payload.register(:event_type) do
  key(:key, String)
  key(:description, String)
end
