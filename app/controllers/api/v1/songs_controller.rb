class API::V1::SongsController < API::V1::APIController
  def show
    @song = Song.find(params[:id])

    @has_been_edited = @song.audits.updates.count.positive?
    Song.increment_counter(:view_count, @song.id, touch: false)

    render json: @song
  end
end