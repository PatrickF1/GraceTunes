class SongsController < ApplicationController

  def index
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
    @song = Song.find(params[:id])
    if params[:new_key]
      Transposer.transpose_song(@song, params[:new_key])
    end

    respond_to do |format|
      format.html do
      end
      format.json do
        render json: @song
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
    params.require(:song).permit(:name, :key, :artist, :tempo, :standard_scan, :chord_sheet)
  end
end
