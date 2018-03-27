require "test_helper"

class AuditsHelperTest < ActionView::TestCase
  test "filter_empty_audited_changes should select only Array values (diffs) and non-blank values" do
    deleted_song_create_audit = audits(:deleted_song_audit_1)
    deleted_song_modify_audit = audits(:deleted_song_audit_2)
    deleted_song_destroy_audit = audits(:deleted_song_audit_3)
    assert_equal({"name" => "Delete Me", "key" => "G"}, filter_empty_audited_changes(deleted_song_create_audit.audited_changes))
    assert_equal({"key" => ["G", "A"], "standard_scan" => ["", "V1."]}, filter_empty_audited_changes(deleted_song_modify_audit.audited_changes))
    assert_equal({ "name" => "Delete Me", "key" => "A", "standard_scan" => "V1."}, filter_empty_audited_changes(deleted_song_destroy_audit.audited_changes))
  end
end