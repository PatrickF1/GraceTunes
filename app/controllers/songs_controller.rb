class SongsController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        songs = Song.all
        total_songs = songs.count

        if params[:sSearch].present?
          search = {
            query: "%#{params[:sSearch]}%",
            rQuery: Regexp.escape(params[:sSearch])
          }

          songs = songs.where('name LIKE :query OR artist LIKE :query OR
            song_sheet REGEXP :rQuery', search)
        end

        song_data = {
          draw: params[:draw].to_i,
          recordsTotal: total_songs,
          recordsFiltered: total_songs - songs.count,
          data: songs.select(:name, :artist, :tempo, :key)
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
