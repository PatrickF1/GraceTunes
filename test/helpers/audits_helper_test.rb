# frozen_string_literal: true

require "test_helper"

class AuditsHelperTest < ActionView::TestCase
  test "filter_empty_audited_changes should select only Array values (diffs) and non-blank values" do
    audited_changes = {
      name: "Song Name",
      bpm: nil,
      artist: "",
      chord_sheet: "Verse 1\n G"
    }
    assert_equal(audited_changes.slice(:name, :chord_sheet), filter_empty_audited_changes(audited_changes))
  end
end
