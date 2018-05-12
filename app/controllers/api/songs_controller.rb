class Api::SongsController < Api::APIController

  def recently_updated
    @songs = if params[:updated_since].present?
      Api::Song.where("updated_at >= ?", params[:updated_since])
    else
      Api::Song.all
    end
  end

end