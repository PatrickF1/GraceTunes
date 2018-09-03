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
  validate :praise_set_songs_integrity

  # returns SongDeletionRecords for deleted songs
  def retrieve_songs
    praise_set_songs.map do |pss|
      song_id = pss["id"]
      if (song = Song.find_by_id(song_id))
        song
      elsif (record = SongDeletionRecord.find_by_id(song_id))
        record
      else
        raise 'Praise set songs references a song that does not and has never existed.'
      end
    end
  end

  private

  def praise_set_songs_integrity
    # validate praise_set_songs is well-formed according to JSON schema
    if !JSON::Validator.validate(PRAISE_SET_SONG_SCHEMA, praise_set_songs)
      errors.add(:praise_set_songs, "does not not have the correct JSON structure")
    else
      # validate that songs ids refer to actual songs or deleted songs
      # assumes that praise_set_songs conforms to its JSON schema, hence it is in the else block
      praise_set_songs.each do |pss|
        song_id = pss["id"]
        if !Song.find_by_id(song_id)
          if !SongDeletionRecord.find_by_id(song_id) # ignore deleted songs
            errors.add(:praise_set_songs, "can't reference song id #{song_id}, which does not exist")
          end
        end
      end
    end
  end

end