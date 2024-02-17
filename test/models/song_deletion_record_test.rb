# frozen_string_literal: true

require "test_helper"

class SongDeletionRecordTest < ActiveSupport::TestCase
  test "should be invalid without an id" do
    deleted_song = SongDeletionRecord.new(
      id: nil,
      name: "Some Name"
    )
    assert_not deleted_song.valid?, "was valid despite not having a name"
  end

  test "should be invalid without a name" do
    deleted_song = SongDeletionRecord.new(
      id: 5,
      name: nil
    )
    assert_not deleted_song.valid?, "was valid despite not having a name"
  end

  test "should automatically assign deleted_at to current time before validating" do
    deleted_song = SongDeletionRecord.new(
      id: 9,
      name: "Some Name"
    )
    assert deleted_song.valid?, "did not automatically assign deleted_at field before validating"
    deleted_at = deleted_song.deleted_at
    assert_not_nil deleted_at, "the deleted_at field was nil"
    assert_in_delta(Time.zone.now, deleted_at, 15, "the deleted_at field was not assigned to a recent time")
  end
end
