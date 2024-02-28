# frozen_string_literal: true

require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "get_page_title appends GraceTunes to end" do
    setup_view_flow
    set_page_title "Some title..."
    assert_match(/GraceTunes$/, get_page_title)
  end

  test "get_page_title returns GraceTunes if no title is set" do
    setup_view_flow
    assert_equal("GraceTunes", get_page_title)
  end

  # content_for requires view_flow to be initialized
  def setup_view_flow
    @view_flow = ActionView::OutputFlow.new
  end
end
