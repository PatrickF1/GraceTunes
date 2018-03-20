require "test_helper"
require_relative 'application_controller_test'

class AuditsControllerTest < ApplicationControllerTest

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

  test "index should retrieve one page of audits" do
    get :index
    assert_equal(assigns(:audits).size, AuditsController::DEFAULT_PAGE_SIZE)
  end

  test "index should retrieve the given page of audits" do
    get :index, params: { page_num: 2 }
    assert_equal([audits(:deleted_song_audit_1)], assigns(:audits))
  end

  test "index should only retrieve audits with the given audit action" do
    get :index, params: { audit_action: "create" }

    audits = assigns(:audits)
    create_audits = [audits(:forever_reign_audit_1), audits(:deleted_song_audit_1)].to_set
    other_audits = [audits(:forever_reign_audit_2), audits(:forever_reign_audit_3),
        audits(:deleted_song_audit_2), audits(:deleted_song_audit_3)].to_set

    assert(audits.to_set == create_audits)
    assert_not(audits.to_set.intersect?(other_audits))
  end
end