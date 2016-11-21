class Song < ActiveRecord::Base
  include PgSearch
  pg_search_scope(
    :search_by_keywords,
    against: {name: 'A', lyrics: 'B', artist: 'B'},
    using: {:tsearch => {any_word: true, prefix: true}}
  )

  has_many :tags, through: :song_tags

  VALID_KEYS = Parser::MAJOR_KEYS
  VALID_TEMPOS = %w(Fast Medium Slow)

  validates :name, presence: true
  validates :chord_sheet, presence: true
  validates_inclusion_of :key, in: VALID_KEYS, allow_nil: false
  validates_inclusion_of :tempo, in: VALID_TEMPOS, allow_nil: false
  before_save :normalize, :extract_lyrics

  def to_s
    name
  end

  private

  # Titlize important fields and strip away unnecessary spaces
  def normalize
    self.name = self.name.titleize.strip
    self.artist = self.artist.titleize.strip if self.artist
    if self.standard_scan
      normalized_scan = self.standard_scan.split(" ").map do |section|
        
      end
    end
    normalized_lines = []
    self.chord_sheet.split("\n").each { |line| normalized_lines << line.rstrip }
    self.chord_sheet = normalized_lines.join("\n")
  end

  def extract_lyrics
    lyrics = self.chord_sheet.split("\n").find_all { |line| Parser.lyrics?(line) }
    self.lyrics = lyrics.join("\n")
  end
end
