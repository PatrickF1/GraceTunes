require 'test_helper'

class SongsFinderTest < ActionController::TestCase
  single_word_results = SongsFinder.search "relevant"
  multi_word_results = SongsFinder.search "truth live life hands"
  partial_word_results = SongsFinder.search 'hand'

  test 'should prioritize songs with keyword in the title' do
    assert_equal(single_word_results.first, songs(:relevant_1))
  end

  test 'should prioritize songs with more occurances of the keyword' do
    assert_equal(single_word_results.second, songs(:relevant_2))
    assert_equal(single_word_results.third, songs(:relevant_3))
  end

  test 'should not include songs without any occurances of the keyword' do
    assert_not_includes(single_word_results, songs(:relevant_4), "Song without keyword appeared in search")
  end

  test 'should include all songs where at least one keyword present' do

    assert_includes(multi_word_results, songs(:God_be_praised))
    assert_includes(multi_word_results, songs(:forever_reign))
    assert_includes(multi_word_results, songs(:hands_to_the_heaven))
  end

  test 'should prioritize songs with more matching keywords' do
    assert_equal(multi_word_results.first, songs(:hands_to_the_heaven))
  end

  test 'empty search should return no results' do
    assert_equal(SongsFinder.search(nil), [])
    assert_equal(SongsFinder.search(""), [])
  end

  test 'retrieve all returns many songs' do
    assert(SongsFinder.retrieve_all.count > 7)
  end

  test 'should partially match' do
    assert_includes(partial_word_results, songs(:hands_to_the_heaven))
    assert_includes(partial_word_results, songs(:glorious_day))
  end
end
