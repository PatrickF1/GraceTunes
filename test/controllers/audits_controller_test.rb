require "test_helper"
require_relative 'application_controller_test'

class AuditsControllerTest < ApplicationControllerTest

  # dynamically generate all the audits data on setup, which should be
  # more maintainable than creating them through audit fixtures
  def setup
    super()
    begin
      # re-enable auditing as it is disabled by default in the test environment
      Song.auditing_enabled = true

      Song.create!(
        name: "A new creation",
        artist: "Artist",
        key: "G",
        tempo: "Medium",
        standard_scan: "V1.",
        chord_sheet: "G      Am     G/B       C"
      )

      forever_reign_song = songs(:forever_reign)
      forever_reign_song.key = "G"
      forever_reign_song.chord_sheet = "C D E F G A B"
      forever_reign_song.save!

      forever_reign_song.standard_scan = "V2. V1."
      forever_reign_song.save!

      song_to_delete = Song.new(
        name: "A Song to Delete",
        key: "G",
        tempo: "Fast",
        chord_sheet: "C    C  D   A  B"
        )
      song_to_delete.save!

      song_to_delete.key = "A"
      song_to_delete.save!

      song_to_delete.destroy!
    ensure
      Song.auditing_enabled = false
    end
  end

  test "index should be retrieved successfully" do
    get :index
    assert_response :success
  end

  test "index should retrieve audits in reverse order" do
    get :index
    assigns(:audits).each_with_index do |audit, index|
      if index < assigns(:audits).size - 1
        assert audit.created_at > assigns(:audits)[index+1].created_at
      end
    end
  end

  test "index should only retrieve audits with the given audit action" do
    get :index, params: { audit_action: AuditAction::CREATE }

    audits = assigns(:audits)
    audits.each do |audit|
      assert_equal(AuditAction::CREATE, audit.action, "retrieved a non-create audit")
    end
    assert_equal(2, audits.length, "did not load all and only create audits")
  end
end