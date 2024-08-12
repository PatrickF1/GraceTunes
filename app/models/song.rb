# frozen_string_literal: true

class Song < ApplicationRecord
  audited except: [:lyrics, :view_count]

  include PgSearch::Model
  pg_search_scope(
    :search_by_keywords,
    against: { name: 'A', artist: 'B', lyrics: 'C' },
    using: { tsearch: { any_word: false, prefix: true } }
  )

  VALID_KEYS = Music::MAJOR_KEYS
  VALID_TEMPOS = %w[Fast Medium Slow].freeze
  VALID_CATEGORIES = %w[Special Hymn Christmas].freeze
  MAX_LINE_LENGTH = 47

  before_validation :normalize
  before_save :extract_lyrics
  before_destroy :record_deletion

  validates :name, presence: true, uniqueness: {
    scope: :artist,
    message: "is taken by another song by this artist"
  }
  validates :key, presence: true
  validates :key, inclusion: { in: VALID_KEYS, if: ->(song) { song.key.present? } }
  validates :tempo, presence: true
  validates :tempo, inclusion: { in: VALID_TEMPOS, if: ->(song) { song.tempo.present? } }
  validates :category, inclusion: { in: VALID_CATEGORIES, if: ->(song) { song.category.present? } }
  validates :chord_sheet, presence: true
  validate :line_length, if: ->(song) { song.chord_sheet.present? }
  validates :spotify_uri,
            format: { with: /\Aspotify:track:\w{22}\z/ },
            if: ->(song) { song.spotify_uri.present? }
  validates :bpm, numericality: {
    allow_nil: true,
    only_integer: true,
    greater_than: 0,
    less_than_or_equal_to: 1000
  }

  def to_s
    name_and_artist = artist.blank? ? name : "#{name} by #{artist}"
    "#{name_and_artist} (id: #{id})"
  end

  # include spotify_widget_source and remove spotify_uri when serialized as JSON hash
  # https://blog.arkency.com/how-to-overwrite-to-json-as-json-in-active-record-models-in-rails/
  def as_json(*)
    super.except("spotify_uri").tap do |json_hash|
      json_hash[:spotify_widget_source] = spotify_widget_source
    end
  end

  def spotify_widget_source
    "https://open.spotify.com/embed?uri=#{spotify_uri}" if spotify_uri.present?
  end

  private

  # Titlize fields, remove unnecessary spaces, make headers all caps
  def normalize
    self.name = name.titleize.strip if name

    self.artist = artist.titleize.strip if artist

    if standard_scan
      self.standard_scan = standard_scan.upcase.split.each do |section_abbr|
        section_abbr.concat(".") if section_abbr[-1] != "."
      end.join(" ")
    end

    return unless chord_sheet

    self.chord_sheet = chord_sheet.split("\n").map do |line|
      line = line.upcase if Parser.header_line?(line)
      line.rstrip
    end.join("\n")
  end

  def extract_lyrics
    lyrics = chord_sheet.split("\n").select { |line| Parser.lyrics_line?(line) }
    self.lyrics = lyrics.join("\n")
  end

  # assumes that chord_sheet is not nil
  def line_length
    line_numbers = []
    chord_sheet.split("\n").each_with_index do |line, i|
      line_numbers << (i + 1) if line.rstrip.length > MAX_LINE_LENGTH
    end
    return unless line_numbers.any?

    line_pluralized = 'line'.pluralize(line_numbers.length)
    line_numbers_string = line_numbers.join(',')
    errors.add(:chord_sheet,
               "#{line_pluralized}: #{line_numbers_string} cannot be longer than #{MAX_LINE_LENGTH} characters long")
  end

  def record_deletion
    SongDeletionRecord.create!(
      id:,
      name:
    )
  end
end
