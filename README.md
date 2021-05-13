Event Warehouse Builder
-------------------------
![Ruby Lint and Test](https://github.com/sanger/event_warehouse/workflows/Ruby%20Lint%20and%20Test/badge.svg)

Description
-----------
RabbitMQ driven event warehouse system for source agnostic event reporting. Records events and associates them with any number of subjects, allowing easy answering of the question 'tell me everything that has happened to x.'

Configuration
-------------
The default configuration is provided in ./config/application if follows the standard rails format. Environment specific configurations can be applied in the matching ./environments/environments_name.rb file.

[event_type_preregistration] If set to true events will only be recorded if their event type is listed in the event dictionary. If false, new event types will be added to the dictionary automatically.

Glossary
--------

- **Event** A single action that can occur, and may be of interest to multiple parties. Events may be associated with one or more Subjects, and may have any number of metadata.
- **Subject** Something associated with a event. An subject can be considered an interested party, either because it was directly subject to an event, or because it is indirectly affected. Subjects may belong to many events. While their subject type will remain constant, the role may be different for each event.
- **Metadata** Key value pair describing custom information regarding an event.

- **EventType** A dictionary of observed or accepted event types with a description. Associated with an event and describes the nature of the event.
- **RoleType** A property of the association of an event with a subject. Defines the way in which the subject is associated with the event.
- **SubjectType** A dictionary of subject types.

- **Role** An association between an event and a subject. Defines the role a subject plays in the event.

- **lims** Present on event, and included as a field in the event message (see Message Format), identifies the originating system. Allows multiple systems to share an event warehouse. (The term LIMS stands for 'Laboratory Information Management System' and reflects the initial use of this event tracker)
- **friendly_name** Present on subject. A human readable, commonly used identifier for the subject. Uniqueness is recommended, but not enforced. In the event that two subjects exist with the same friendly name, uuid and subject type can assist with disambiguation.

Example
-------

Alice has a pot-plant called Chuck. She delivers this to Bob. This gets logged as an event. In this scenario you'd have a 'delivery' event; 'Alice' and 'Bob' would both be subjects, with a subject type of 'person,' their 'friendly_name' could be something like an email address or a login, these are easy to read but should also be unique. Alice would have a role of 'sender' and Bob of 'recipient'. Meanwhile Chuck would be another subject, with the type 'plant' and a 'friendly_name' of 'Chuck', the role however would be 'package'.

Note that when Bob decides to return the favour by sending Alice a cake, their roles are reversed. Each person will still exist as just one subject, but will have two Roles, each with a different RoleType. Meanwhile the cake will be a new subject with type 'cake' but it will have a 'package' role, just as Chuck did. Hence while a subjects type describes what a subject IS, and should be static, its role describes what it DOES, and is defined on a pre event basis. Additionally, a given event type may have a role that could be filled by multiple subject types.

Meanwhile Eve is able to tell that all this is going on by tracking the entries being inserted into the database.

Why normalized?
---------------
Events are highly varied in nature, and in terms of the number and types of subjects that may be associated with them. A standard denormalized structure would be tricky to achieve for all events. While we could insert one row per subject, this would make it tricky to form queries identifying events associated with two or more particular subjects.

Message Format
--------------

All messages are received in JSON format via a message queue (RabbitMQ). The example below illustrates the scenario described in the 'Example' section. occurred_at records a timestamp for the event, whereas user_identifier records the person or process responsible for the event.

```json
{
  "event":{
    "uuid":"00000000-1111-2222-3333-444444444444",
    "event_type":"delivery",
    "occured_at":"2012-03-11 10:22:42",
    "user_identifier":"postmaster@example.com",
    "subjects":[
      {
        "role_type":"sender",
        "subject_type":"person",
        "friendly_name":"alice@example.com",
        "uuid":"00000000-1111-2222-3333-555555555555"
      },
      {
        "role_type":"recipient",
        "subject_type":"person",
        "friendly_name":"bob@example.com",
        "uuid":"00000000-1111-2222-3333-666666666666"
      },
      {
        "role_type":"package",
        "subject_type":"plant",
        "friendly_name":"Chuck",
        "uuid":"00000000-1111-2222-3333-777777777777"
      }
    ],
    "metadata":{
      "delivery_method":"courier",
      "shipping_cost":"15.00"
    }
  },
  "lims":"example"
}
```

Seeds
-----
The the files in the ./db/seeds/ directory are used to seed the dictionaries for event_types, role_types and subject_types. Each file contains on array of ['key','description'] arrays. They will automatically be inserted into the database when you run `rake db:seed`. In addition `rake dictionaries:update` may be used to automatically insert any missing records, or to update the descriptions of existing records. `rake dictionaries:update` will not remove dictionary entries which are missing from the seeds file.

The existing entries correspond to the requirements of the Sanger, and are not required for normal operation.

Development Environment
-----------------------
In order to run the events warehouse locally, you will need to:
- create local databases: run `bundle exec rails db:create`;
- configure local databases: run `bundle exec rails db:schema:load`;
- seed local databases: run `bundle exec rails db:seed`;
- have a RabbitMQ server running locally: this can be done through _brew services_;
- start the consumer: in a terminal run `bundle exec warren consumer start`;

## Integration Tests Setup

In order to run configure the event warehouse database for running
integration tests in dependent projects:

1. Setup the testing database

```
   bundle exec rake db:reset
```

This action can be performed automatically if you run the Docker container of the service
and pass the environment variables:
```
RAILS_ENV="test"
INTEGRATION_TEST_SETUP="true"
```

### For Integration test from Unified Warehouse

1. Only for unified warehouse, load the specific set of seeds for integration tests:

```
   RAILS_ENV=test bundle exec rails runner spec/data/integration/seed_for_unified_wh.rb

```

This action can be performed automatically if you run the Docker container of the service
and pass the environment variables:
```
RAILS_ENV="test"
INTEGRATION_TEST_SETUP="true"
INTEGRATION_TEST_SEED="/code/spec/data/integration/seed_for_unified_wh.rb"
```
