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
  validate :praise_set_songs_foreign_keys, if: Proc.new { |p| p.errors[:praise_set_songs].empty? }

  # returns SongDeletionRecords for deleted songs
  def retrieve_songs
    praise_set_songs.map do |pss|
      song_id = pss["id"]
      if (song = Song.find_by_id(song_id))
        song
      elsif (record = SongDeletionRecord.find_by_id(song_id))
        record
      else
        raise 'Praise set references a song that does not exist.'
      end
    end
  end

  private
  # assumes that praise_set_songs conforms to its JSON schema
  def praise_set_songs_foreign_keys
    praise_set_songs.each do |pss|
      song_id = pss["id"]
      if not Song.find_by_id(song_id)
        if not SongDeletionRecord.find_by_id(song_id) # ignore deleted songs
          errors.add(:praise_set_songs, "can't reference song id #{song_id}, which does not exist")
        end
      end
    end
  end

end