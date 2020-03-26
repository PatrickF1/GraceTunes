# Songs controller
class API::V2::SongsController < API::V2::APIController
  # GET /
  def index
    render json: @songs
  end

  # POST /
  def create
    render json: Song.create!(song_params), status: :created
  end

  # GET /:id
  def show
    render json: @song
  end

  # PUT /:id
  def update
    @song.update!(song_params)
    render json: @song
  end

  # DELETE /:id
  def destroy
    @song.destroy!
    head :no_content
  end

  def song_params
    params.require(:song)
        .permit(:name, :artist, :key, :tempo, :chord_sheet, :bpm, :spotify_uri)
  end
end
