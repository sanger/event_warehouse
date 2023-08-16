# frozen_string_literal: true

# Disable cops as we want to match the original coding as closely as possible
# rubocop:disable all
# Monkey patch MySQL compatibility to default to no quoting:
# include_related[key][include_related]
class JSONAPI::ActiveRelationResource
    def self.sql_field_with_alias(table, field, quoted = false)
      Arel.sql("#{concat_table_field(table, field, quoted)} AS #{alias_table_field(table, field, quoted)}")
    end
end