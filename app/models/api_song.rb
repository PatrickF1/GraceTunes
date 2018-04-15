class ApiSong
  def initialize(song)
    @id = song.id
    @name = song.name
    @artist = song.artist
    @tempo = song.tempo
    @bpm = song.bpm
    @standard_scan = song.standard_scan
    @chord_sheets = {}
    Song::VALID_KEYS.map do |key|
      cloned_song = song.clone
      Transposer.transpose_song(cloned_song, key)
      @chord_sheets[key] = cloned_song.chord_sheet
    end
    @chord_sheets['numeral'] = Formatter.format_song_nashville(song)
  end
end