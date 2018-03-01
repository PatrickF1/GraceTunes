class AuditsController < ApplicationController

  def song_history
    @song = Song.find(params[:id])
    @update_audits = @song.audits.where(action: 'update')
  end
end