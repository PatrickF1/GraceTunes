class SongsFinder
  
  def self.search(query)
    return [] if query.blank?
    
    Song.find_by_sql <<-SQL.squish
      SELECT
        *,
        MATCH (name) AGAINST ('>(#{query})' IN BOOLEAN MODE) +
        MATCH (song_sheet) AGAINST ('(#{query})' IN BOOLEAN MODE) AS relevance
      FROM 
        songs 
      WHERE 
        MATCH(name, song_sheet) AGAINST ('#{query}' IN BOOLEAN MODE)
      ORDER BY 
        relevance
      DESC
    SQL
      
  end

  def self.retrieve_all
    Song.order(:name)
  end
end