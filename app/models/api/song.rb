class API::Song < ApplicationRecord

  self.ignored_columns = %w(created_at lyrics spotify_uri)

  def as_json(options = nil)
    suggested_key = self.key # Transposer.transpose_song destructively modifies key so save it
    chord_sheets = {}
    Music::MAJOR_KEYS.map do |key|
      cloned_song = clone
      Transposer.transpose_song(cloned_song, key)
      chord_sheets[key] = cloned_song.chord_sheet
    end
    chord_sheets['numeral'] = Formatter.format_song_nashville(self)

    super(except: [:created_at, :key, :chord_sheet, :lyrics, :spotify_uri])
      .merge(chord_sheets: chord_sheets)
      .merge(key: suggested_key)
  end
end