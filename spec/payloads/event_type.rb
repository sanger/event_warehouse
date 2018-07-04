# frozen_string_literal: true

JsonapiSpecHelpers::Payload.register(:event_type) do
  key(:key, String, description: 'A short string identifying the event type')
  key(:description, String, description: 'A brief description of the event type')
end
