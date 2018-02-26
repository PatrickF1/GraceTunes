class AuditsController < ApplicationController

  def index
    page_num = params[:page_num] ? params[:page_num] : 1
    audits = Audit.history
    audits = audits.paginate(page: page_num, per_page: 5)
    @audits_to_song_map = Hash[audits.collect { |audit| [audit, Song.find(audit.auditable_id)] }]
  end

  def song_history
    @song = Song.find(params[:id])
    @audits = @song.audits
  end
end