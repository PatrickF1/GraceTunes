class Api::SongsController < API::APIController

  def recently_updated
    songs = if params[:updated_since].present?
      Song.where("updated_at >= ?", params[:updated_since])
    else
      Song.all
    end
    @songs = songs.map { |song| API::Song.new(song) }
  end

end