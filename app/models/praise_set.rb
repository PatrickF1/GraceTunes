class PraiseSet < ApplicationRecord

  PRAISE_SET_SONG_SCHEMA = {
    type: "array",
    items: {
      type: "object",
      required: ["id", "key"],
      properties: {
        id: { type: "integer" },
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
  validate :praise_set_songs_foreign_keys

  def praise_set_songs_foreign_keys
    if errors.empty?
      praise_set_songs.each do |pss|
        if (song_id = pss["id"]).is_a? Integer
          if not Song.find_by_id(song_id)
            errors.add(:praise_set_songs, "can't reference song id #{song_id}, which does not exist")
          end
        end
      end
    end
  end

end