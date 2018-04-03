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

    @audits_to_song_map = @audits.collect do |audit|
      song = Song.find_by(id: audit.auditable_id)
      if song.nil?
        # the song for this audit has been destroyed. we can recreate it by finding the 'destroy' audit for this song
        # and using its audited_changes
        # need the song for its name and id on the front end
        destroy_audit = Audit.find_by(action: Audit::DESTROY, auditable_id: audit.auditable_id)
        song = Song.new(destroy_audit.audited_changes)
      end
      [audit, song]
    end.to_h
  end

  def song_history
    @song = Song.find(params[:id])
    @update_audits = @song.audits.updates
  end
end