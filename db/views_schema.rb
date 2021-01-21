# This is an automatically generated file by rake:db:views:dump_schema
require './lib/views_schema'
ViewsSchema.create_view(
'flat_events_view',
%Q{select `events`.`id` AS `wh_event_id`,`events`.`uuid` AS `event_uuid_bin`,insert(insert(insert(insert(lower(hex(`events`.`uuid`)),9,0,'-'),14,0,'-'),19,0,'-'),24,0,'-') AS `event_uuid`,`event_types`.`key` AS `event_type`,`events`.`occured_at` AS `occured_at`,`events`.`user_identifier` AS `user_identifier`,`role_types`.`key` AS `role_type`,`subject_types`.`key` AS `subject_type`,`subjects`.`friendly_name` AS `subject_friendly_name`,insert(insert(insert(insert(lower(hex(`subjects`.`uuid`)),9,0,'-'),14,0,'-'),19,0,'-'),24,0,'-') AS `subject_uuid`,`subjects`.`uuid` AS `subject_uuid_bin` from (((((`events` left join `event_types` on((`events`.`event_type_id` = `event_types`.`id`))) left join `roles` on((`roles`.`event_id` = `events`.`id`))) left join `role_types` on((`roles`.`role_type_id` = `role_types`.`id`))) left join `subjects` on((`roles`.`subject_id` = `subjects`.`id`))) left join `subject_types` on((`subjects`.`subject_type_id` = `subject_types`.`id`)))},
algorithm: 'UNDEFINED', security: 'DEFINER'
)
