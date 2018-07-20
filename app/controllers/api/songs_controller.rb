class API::SongsController < API::APIController

  def recently_updated
    @songs = if params[:updated_since].present?
      API::Song.where("updated_at >= ?", params[:updated_since])
    else
      API::Song.all
    end
  end

  def deleted
    @song_deletion_records = if params[:since].present?
      SongDeletionRecord.where("deleted_at >= ?", params[:since])
    else
      SongDeletionRecord.all
    end
  end

end