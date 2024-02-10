require_relative 'api_controller_test_base'
class API::AuditsControllerTest < API::ControllerTestBase

  # dynamically generate all the audits data on setup, which should be
  # more maintainable than creating them through audit fixtures
  def setup
    super()
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
  end

  test "song_history requires user to be signed in" do
    sign_out
    get :song_history, params: { id: 1 }
    assert_response :forbidden
  end

  test "song_history should retrieve the audits for the specified song" do
    id = songs(:forever_reign)
    get :song_history, params: { id: id }

    assert @response.parsed_body.map{ |audit| audit['action'] } == [AuditAction::UPDATE, AuditAction::UPDATE]
  end

  test "songs_history_index requires user to be signed in" do
    sign_out
    get :songs_history_index
    assert_response :forbidden
  end

  test "songs_history_index should retrieve audits in reverse order" do
    get :songs_history_index

    audits = @response.parsed_body['data'].map { |audit_tuple| audit_tuple[0] }
    prev_created_at = '3099-01-01T00:00:00'
    audits.each do |audit|
      assert audit['created_at'] < prev_created_at
      prev_created_at = audit['created_at']
    end
  end

  test "songs_history_index should only retrieve audits with the given action" do
    get :songs_history_index, params: { action_type: AuditAction::CREATE }

    audits = @response.parsed_body['data'].map { |audit_tuple| audit_tuple[0] }
    audits.each do |audit|
      assert_equal(AuditAction::CREATE, audit['action'], "retrieved a non-create audit")
    end
    assert_equal(2, audits.length, "did not load all and only create audits")
  end

end
