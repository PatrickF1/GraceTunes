class PraiseSetSong
  include ActiveModel::Model

  attr_accessor :song_id, :song_key

  validates :song_id, presence: true
  validates :song_key, presence: true
  validates_inclusion_of :song_key, in: Music::MAJOR_KEYS, if: -> (song) { song.song_key.present? }

  def initialize(id, key)
    @song_id = id
    @song_key = key
  end

  class ArraySerializer
    def self.load(value)
      case value
        when Array
          value.map do |item|
            PraiseSetSong.new(item.song_id, item.song_key)
          end
        else
          raise ArgumentError, 'was expecting value to be an Array'
      end
    end

    def self.dump(array)
      array.map(&:attributes)
    end
  end

end