class SongsController < ApplicationController
  def index
    @songs = Song.all
  end

  def new
  end

  def edit
  end
  
  def search
    @results = true
    if params[:search].nil?
      @songs = Song.all
    else
      @songs = Song.search params[:search]
      if @songs.nil? or @songs.none?
        flash[:notice] = "No result found"
        @results = false
        @songs = Song.all
      end
    end
  end
end
