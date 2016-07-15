require 'test_helper'

class SongsControllerTest < ActionController::TestCase
  # test "should get index" do
  #   get :index
  #   assert_response :success
  # end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit
  #   assert_response :success
  # end
  
  test "search should render correct template and layout" do
    get :search
    assert_response :success
    assert_template :search
  end
  
  test "should notify when no results are found" do
    get(:search, {'search' => 'banana'})
    assert_response :success
    assert_equal flash[:notice], "No result found"
  end
  
  test "should display the right search results" do
    get(:search, {'search' => 'praise'})
    assert_response :success
    assert_select 'td', "God Be Praised"
    assert_select 'td', {count: 0, text: "10,000 Reasons"}
  end
  
  test "should route to post" do
    assert_routing '/search', {controller: "songs", action: "search"}
  end

end
