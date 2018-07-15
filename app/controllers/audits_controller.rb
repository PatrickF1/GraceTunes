class AuditsController < ApplicationController

  DEFAULT_PAGE_SIZE = 5

  def index
    @page_num = params[:page_num] ? params[:page_num].to_i : 1
    page_size = params[:page_size] ? params[:page_size].to_i : DEFAULT_PAGE_SIZE
    @audits = Audit.history
    if Audit.valid_action(params[:audit_action])
      @audit_action_filter = params[:audit_action]
      @audits = @audits.where(action: @audit_action_filter)
    end
    @audits = @audits.paginate(page: @page_num, per_page: page_size)

    @audits_info_list = @audits.map do |audit|
      song = Song.find_by(id: audit.auditable_id)
      if song.nil?
        is_deleted = true
        song_name = SongDeletionRecord.find(audit.auditable_id).name
      else
        is_deleted = false
        song_name = song.name
      end
      [audit, song_name, is_deleted]
    end
  end

  def song_history
    @song = Song.find(params[:id])
    @update_audits = @song.audits.updates
  end
end