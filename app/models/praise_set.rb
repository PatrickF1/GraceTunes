class PraiseSet < ApplicationRecord
  PRAISE_SET_SONG_SCHEMA = {
    type: "array",
    items: {
      type: "object",
      required: ["id", "key"],
      properties: {
        id: { "type": "number" },
        key: {
          type: "string",
          enum: Song::VALID_KEYS
        }
      }
    }
  }

  belongs_to :owner, :foreign_key => "owner_email", :primary_key => "email", :class_name => "User"

  validates :event_name, presence: true
  validates :event_date, presence: true
  validates :owner, presence: true
  validates_inclusion_of :archived, in: [true, false]
  validates :praise_set_songs, presence: true, json: { schema: PRAISE_SET_SONG_SCHEMA }

end