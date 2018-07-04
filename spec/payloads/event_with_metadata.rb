# frozen_string_literal: true

JsonapiSpecHelpers::Payload.register(:event_with_metadata) do
  key(:lims_id, String)
  key(:occured_at, String)
  key(:user_identifier, String)
  key(:metadata, Hash, &:metadata_hash)
end
