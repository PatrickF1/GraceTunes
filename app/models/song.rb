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
  MAX_LINE_LENGTH = 45

  validates :name, presence: true
  validates :chord_sheet, presence: true
  validates_inclusion_of :key, in: VALID_KEYS, allow_nil: false
  validates_inclusion_of :tempo, in: VALID_TEMPOS, allow_nil: false
  validate :line_length
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
    lyrics = self.chord_sheet.split("\n").find_all { |line| Parser.lyrics?(line) }
    self.lyrics = lyrics.join("\n")
  end

  def line_length
    return if self.chord_sheet.nil?
    self.chord_sheet.split("\n").each do |line|
      if(line.length > MAX_LINE_LENGTH)
        errors.add(:chord_sheet, "has a line that is too long: " + line)
      end
    end
  end
end
