class Song < ActiveRecord::Base
  
  include PgSearch
  pg_search_scope(
    :search_by_keywords, 
    against: {name: 'A', lyrics: 'B', artist: 'B'},
    using: {:tsearch => {any_word: true, prefix: true}}
  )

  has_many :tags, through: :song_tags
  
  VALID_KEYS = %w(Ab A Bb B C C# D Eb E F F# G G#)
  VALID_TEMPOS = %w(Fast Medium Slow)

  validates :name, presence: true
  validates :chord_sheet, presence: true
  validates_inclusion_of :key, in: VALID_KEYS, allow_nil: true
  validates_inclusion_of :tempo, in: VALID_TEMPOS, allow_nil: true
  before_save :normalize, :extract_lyrics

  def to_s
    name
  end

  private
  # Titlize important fields and strip away unnecessary spaces
  def normalize
    self.name = self.name.titleize.strip
    self.artist = self.artist.titleize.strip if self.artist
    
    normalized_lines = []
    self.chord_sheet.split("\n").each { |line| normalized_lines << line.rstrip }
    self.chord_sheet = normalized_lines.join("\n")
  end

  def extract_lyrics
    lyrics = self.chord_sheet.split("\n").find_all { |line| is_line_of_lyrics(line) }
    self.lyrics = lyrics.join("\n")
  end

  CHORD_GIVEAWAY_STRINGS = Set.new(%w(# / [ 2 3 4 7 9))
  def is_line_of_lyrics(line)
    # headers always end with :
    return false if line[-1] == ":"
    # chord lines contain these giveaway substrings
    return false if line.split.any? {|word| CHORD_GIVEAWAY_STRINGS.include? word}
    # lyric lines have low density of spaces and contain 2+ words
    return (line.count(" ") / line.length.to_f < 0.31) && (line.length > 6)
  end
end
