require "test_helper"

class DeletedSongTest < ActiveSupport::TestCase
  test "should not save without an id" do
    deleted_song = DeletedSong.new(
          id: nil,
          name: "Some Name"
        )
    assert_not deleted_song.save, "saved a deleted song without an id"
  end

  test "should not save without a name" do
    deleted_song = DeletedSong.new(
          id: 5,
          name: nil
        )
    assert_not deleted_song.save, "saved a deleted song without an id"
  end

  test "should automatically assign deleted_at to current time on save" do
    deleted_song = DeletedSong.new(
        id: 1,
        name: "Some Name"
      )
    assert deleted_song.save, "could not save deleted song without the deleted_at field"
    deleted_at = deleted_song.deleted_at
    assert_not_nil deleted_at, "the deleted_at field was nil"
    assert_in_delta(Time.now, deleted_at, 15, "the deleted_at field was not assigned to a recent time")
  end
end