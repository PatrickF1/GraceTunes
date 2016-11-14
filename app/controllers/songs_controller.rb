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
      song = Song.find(params[:id])
      original_key = song.key
      if params[:new_key]
        Transposer.transpose_song(song, params[:new_key])
      end

      format.json do
        render json: {
          song: song.as_json.merge(edit_path: edit_song_path(song), 
            print_path: print_song_path(song, new_key: params[:new_key]),
            original_key: original_key)
        }
      end
    end
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)
    if @song.save
      flash[:success] = "#{@song} successfully created!"
      # TODO: redirect to @song once show action implemented
      redirect_to action: :index
    else
      flash.now[:error] = "Error: #{@song.errors.messages}"
      render :new
    end
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])
    if @song.update_attributes(song_params)
      flash[:success] = "#{@song} successfully updated!"
      redirect_to action: :index
    else
      flash.now[:error] = "Error: #{@song.errors.messages}"
      render :edit
    end
  end

  def print
    @song = Song.find(params[:id])
    if params[:new_key].present?
      Transposer.transpose_song(@song, params[:new_key])
    end
    render layout: false
  end

  private
  def song_params
    params.require(:song).permit(:name, :key, :artist, :tempo, :chord_sheet)
  end
end
