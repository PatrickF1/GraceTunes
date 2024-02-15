# frozen_string_literal: true

class API::SongsController < API::APIController
  before_action :require_edit_privileges, only: [:create, :update]
  before_action :require_delete_privileges, only: [:destroy]

  def show
    song = Song.find_by(id: params[:id])
    return head(:not_found) unless song

    case params[:sheet_format]
    when 'nashville'
      Formatter.format_song_nashville(song)
    when 'no_chords'
      Formatter.format_song_no_chords(song)
    else
      Transposer.transpose_song(song, params[:key]) if params[:key].present?
    end

    Song.increment_counter(:view_count, song.id, touch: false)

    render json: song
  end

  def index
    songs = Song

    # perform searching and filtering
    # pg_search requires search_by_keywords to be to run first before anything else
    songs = songs.search_by_keywords(params[:query]) if params[:query].present?
    songs = songs.where(key: params[:key]) if params[:key].present?
    songs = songs.where(tempo: params[:tempo]) if params[:tempo].present?
    songs = songs.select('id, artist, tempo, key, name, chord_sheet, spotify_uri')
    matching_songs_count = songs.size

    # perform sorting
    songs =
      case params[:sort_by]
      when 'created_at'
        songs.reorder(created_at: :desc)
      when 'name'
        songs.reorder(name: :asc)
      when 'views'
        songs.reorder(view_count: :desc)
      else
        # if search_by_keywords was run, then the results are already sorted by relevance
        songs
      end

    # perform paginate
    page_num = params[:page_num]&.to_i || 1
    page_size = [params[:page_size]&.to_i || DEFAULT_PAGE_SIZE, 500].min
    songs = songs.paginate(page: page_num, per_page: page_size)

    render_paginated_result(songs, matching_songs_count, Song.count)
  end

  def create
    song = Song.new(song_params)
    if song.save
      flash[:success] = "#{song.name} successfully created!"
      render json: song
    else
      render_form_errors("Couldn't save song", song.errors)
    end
  end

  def update
    song = Song.find(params[:id])
    if song.update(song_params)
      render json: song
    else
      render_form_errors("Couldn't edit song", song.errors)
    end
  end

  def destroy
    if Song.destroy_by(id: params[:id]).empty?
      head :not_found
    else
      head :no_content
    end
  end

  private

  def song_params
    params.require(:song)
          .permit(:name, :key, :artist, :tempo, :bpm, :standard_scan, :chord_sheet, :spotify_uri)
  end
end
