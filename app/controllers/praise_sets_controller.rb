class PraiseSetsController < ApplicationController

  before_action :require_edit_privileges, only: [:new, :create, :edit, :update]
  before_action :require_delete_privileges, only: [:destroy] # implement destroy later

  def index
    respond_to do |format|
      @praise_sets = PraiseSet.order(event_date: :desc)
      format.json do
        render json: @praise_sets and return
      end
      format.html do
      end
    end
  end

  def new
    @praise_set = PraiseSet.new
  end

  def show
    @praise_set = PraiseSet.find(params[:id])

    respond_to do |format|
      format.html do
      end
      format.json do
        render json: @praise_set
      end
    end
  end

  def create
    @praise_set = PraiseSet.new(praise_set_params)
    if @praise_set.save!
      flash[:success] = "#{@praise_set.event_name} set successfully created!"
      logger.info "New praise set created: #{current_user} created #{@praise_set.event_name} set"
      redirect_to edit_praise_set_path(@praise_set)
    else
      render :new
    end
  end

  def edit
    @praise_set = PraiseSet.find(params[:id])
  end

  def add_song
    @praise_set = PraiseSet.find(params[:id])
    @song = Song.find(params[:song_id])
    @praise_set.songs << @song

    if request.xhr?
      render partial: "praise_set_song", locals: { song: @song }
    end
  end

  def remove_song
    praise_set = PraiseSet.find(params[:id])
    deleted_song = praise_set.songs.delete(params[:song_id])

    render json: deleted_song
  end

  private

  def praise_set_params
    # don't permit song_ids since songs need to be added after the praise set is created for act_as_list to work
    params.require(:praise_set).permit(:owner_email, :event_name, :event_date, :notes)
  end
end