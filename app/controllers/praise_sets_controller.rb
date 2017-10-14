class PraiseSetsController < ApplicationController

  before_action :set_praise_set, only: [:show, :edit, :update, :add_song, :remove_song, :set_song_position]
  before_action :require_praise_set_permission, only: [:show, :edit, :update, :add_song, :remove_song, :set_song_position, :set_song_key]

  def index
    respond_to do |format|
      @praise_sets = PraiseSet.order(event_date: :desc).where(owner_email: session[:user_email])
      format.json do
        render json: @praise_sets and return
      end
      format.html do
      end
    end
  end

  def show
    respond_to do |format|
      format.html do
      end
      format.json do
        render json: @praise_set
      end
    end
  end

  def new
    @praise_set = PraiseSet.new
  end

  def create
    @praise_set = PraiseSet.new(praise_set_params)
    @praise_set.owner_email = session[:user_email]
    @praise_set.archived = false
    if @praise_set.save
      flash[:success] = "#{@praise_set.event_name} set successfully created!"
      logger.info "New praise set created: #{current_user} created #{@praise_set.event_name} set"
      redirect_to edit_praise_set_path(@praise_set)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @praise_set.update_attributes(praise_set_params)
      flash[:success] = "#{@praise_set.event_name} set successfully updated!"
      logger.info "Praise Set updated: #{current_user} updated #{@praise_set}"
      redirect_to edit_praise_set_path(@praise_set)
    else
      render :edit
    end
  end

  def add_song
    @song = Song.find(params[:song_id])
    @praise_set.add_song(@song)

    if request.xhr?
      render partial: "praise_set_song", locals: { song: @song, praise_set_song: @praise_set.praise_set_songs.last }
    end
  end

  def remove_song
    deleted_praise_set_song = @praise_set.praise_set_songs.delete(params[:praise_set_song_id])
    render json: deleted_praise_set_song
  end

  def set_song_position
    praise_set_song = PraiseSetSong.find_by(id: params[:praise_set_song_id])
    if params[:new_position]
      praise_set_song.insert_at(params[:new_position].to_i)
    end
  end

  def set_song_key
    praise_set_song = PraiseSetSong.find_by(id: params[:praise_set_song_id])
    if params[:new_key]
      praise_set_song.key = params[:new_key]
      praise_set_song.save!
    end
  end

  private

  def praise_set_params
    # don't permit song_ids since songs need to be added after the praise set is created for act_as_list to work
    params.require(:praise_set).permit(:event_name, :event_date, :notes)
  end

  def set_praise_set
    @praise_set = PraiseSet.find(params[:id])
  end
end