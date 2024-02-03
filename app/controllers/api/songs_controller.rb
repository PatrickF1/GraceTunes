class API::SongsController < API::APIController
  def create
    @song = Song.new(song_params)
    if @song.save
      flash[:success] = "#{@song.name} successfully created!"
      render json: @song
    else
      render json: API::APIError.new("Couldn't save song", @song.errors), status: :bad_request
    end
  end

  private

  def song_params
    params.require(:song)
          .permit(:name, :key, :artist, :tempo, :bpm, :standard_scan, :chord_sheet, :spotify_uri)
  end
end