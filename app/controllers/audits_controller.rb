class AuditsController < ApplicationController

  def song_history
    @song = Song.find(params[:id])
    @audits = @song.audits
  end
end