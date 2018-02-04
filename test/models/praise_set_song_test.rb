require 'test_helper'

class PraiseSetSongTest < ActiveSupport::TestCase

  test "should not save without key" do
    praise_set_song = praise_set_songs(:hillsong_song_1)
    praise_set_song.key = nil
    assert_not praise_set_song.save, "Saved without key"
  end

end
