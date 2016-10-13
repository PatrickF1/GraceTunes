class SongsController < ApplicationController
  def index
    @tempo_opts = [['Any', '']] + Song::VALID_TEMPOS.map { |t| [t, t] }
    @key_opts = [['Any', '']] + Song::VALID_KEYS.map { |k| [k, k] }

    respond_to do |format|
      format.json do
        songs = Song.all
        total_songs = songs.count

        if params[:search][:value].present?
          songs = Song.search_by_keywords(params[:search][:value])
        end

        songs = songs.where(key: params[:key]) if params[:key].present?
        songs = songs.where(tempo: params[:tempo]) if params[:tempo].present?
        songs = songs.select('id, artist, tempo, key, name')

        song_data = {
          draw: params[:draw].to_i,
          recordsTotal: total_songs,
          recordsFiltered: total_songs - songs.size,
          data: songs
        }

        render json: song_data and return
      end

      format.html do
        return
      end
    end
  end

  def show
    respond_to do |format|
      @song = Song.find(params[:id])
      song = @song
      format.json do
        render json: {
          song: @song.as_json.merge(edit_path: edit_song_path(@song))
        }
      end
    end
  end

  def new
  end

  def edit
  end
end
