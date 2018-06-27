# frozen_string_literal: true

JsonapiSpecHelpers::Payload.register(:event) do
  key(:lims_id, String)
  key(:occured_at, String)
  key(:user_identifier, String)
end
