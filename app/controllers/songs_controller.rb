class SongsController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        songs = Song.all
        total_songs = songs.count
        songs = Song.search_by_keywords(params[:sSearch]) if params[:sSearch].present?
        
        song_data = {
          draw: params[:draw].to_i,
          recordsTotal: total_songs,
          recordsFiltered: total_songs - songs.count,
          data: songs
        }

        render json: song_data and return
      end

      format.html do
        return
      end
    end
  end

  def new
  end

  def edit
  end
end
