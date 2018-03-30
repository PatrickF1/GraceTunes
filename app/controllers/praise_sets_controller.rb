class PraiseSetsController < ApplicationController

  before_action :set_praise_set, only: [:show, :edit, :update, :archive, :unarchive]
  before_action :require_praise_set_permission, only: [:show, :edit, :update, :archive, :unarchive]

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

  def archive
    @praise_set.archived = true
    @praise_set.save
    redirect_to edit_praise_set_path(@praise_set)
  end

  def unarchive
    @praise_set.archived = false
    @praise_set.save
    redirect_to edit_praise_set_path(@praise_set)
  end

  private

  def praise_set_params
    params.require(:praise_set).permit(:event_name, :event_date, :notes, praise_set_songs: [:song_id, :song_key])
  end

  def set_praise_set
    @praise_set = PraiseSet.find(params[:id])
  end
end