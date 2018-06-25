# frozen_string_literal: true

# A property of the association of an event with a subject.
# Defines the way in which the subject is associated with the event.
# E.g. Imagine a 'delivery' event recording the delivery of a parcel
# from one person to another. Both people would have the subject type 'person'
# but would have different role types, such as 'sender' and 'recipient'
# For some subjects it may be difficult to meaningfully identify a role_type
# which is distinct from the subject_type in certain events. In these cases the
# role_type will usually match the subject_type.
class RoleType < ApplicationRecord
  include ResourceTools::TypeDictionary

  has_default_description EventWarehouse::Application.config.default_role_type_description
  preregistration_required false
end
