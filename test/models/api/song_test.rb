require "test_helper"

class API::SongTest < ActiveSupport::TestCase
  test "as_json should include correct suggested key in the field \"key\"" do
    song = songs(:God_be_praised)
    assert_equal(
      song.key,
      song.as_json["key"],
      "The suggested key was wrong after serializing to JSOn."
    )
  end
end
