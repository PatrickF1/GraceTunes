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
      @chord_sheets[key] = Transposer.transpose_song(song, key)
    end
    @chord_sheets['numeral'] = Formatter.format_song_nashville(song)
  end
end