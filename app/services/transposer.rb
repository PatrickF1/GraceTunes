class Transposer
  def self.transpose_song(song, new_key)
    parser = Parser.new(song.chord_sheet, song.key)
    song.chord_sheet = parser.transpose_to(new_key)
    song.key = new_key
  end
end