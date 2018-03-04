class AuditsController < ApplicationController

  PAGE_SIZE = 5

  def index
    @page_num = params[:page_num] ? params[:page_num].to_i : 1
    @audits = Audit.history
    @audit_action_filter = params[:audit_action] if Audit.valid_action(params[:audit_action])
    if @audit_action_filter
      @audits = @audits.where(action: @audit_action_filter)
    end
    @audits = @audits.paginate(page: @page_num, per_page: PAGE_SIZE)

    @audits_to_song_map = @audits.collect do |audit|
      song = Song.find_by(id: audit.auditable_id)
      if song.nil?
        destroy_audit = Audit.find_by(action: Audit::DESTROY, auditable_id: audit.auditable_id)
        song = Song.new(destroy_audit.audited_changes)
      end
      [audit, song]
    end.to_h
  end

  def song_history
    @song = Song.find(params[:id])
    @audits = @song.audits
  end
end