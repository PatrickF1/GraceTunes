class SongsFinder

  def self.search(keywords)
    return [] if keywords.blank?

    # The + allows for exact matches, the * is a wildcard. We want to match
    # every word in the string exactly, but allow partial matches for the
    # last word since the search is performed as the user types
    keywords << '*'
    weighted_query = ActiveRecord::Base::sanitize(">(#{keywords})")
    unweighted_query = ActiveRecord::Base::sanitize(keywords)

    Song.find_by_sql <<-SQL.squish
      SELECT
        *,
        MATCH (name) AGAINST (#{weighted_query} IN BOOLEAN MODE) +
        MATCH (song_sheet) AGAINST (#{unweighted_query} IN BOOLEAN MODE) AS relevance
      FROM
        songs
      WHERE
        MATCH(name, song_sheet) AGAINST (#{unweighted_query} IN BOOLEAN MODE)
      ORDER BY
        relevance
      DESC
    SQL

  end

  def self.retrieve_all
    Song.order(:name)
  end
end
