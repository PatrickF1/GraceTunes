require "render_anywhere"

class SongPdf
  include RenderAnywhere

  PDF_CONFIG = {
    zoom: 6,
    margin: {
      left: 1
    }
  }
  FOLDER_PATH = "app/assets/pdf";

  def initialize(song)
    @song = song
  end

  def save_pdf
    pdf = WickedPdf.new.pdf_from_string(generate_html, PDF_CONFIG)
    save_path = Rails.root.join(FOLDER_PATH, get_file_name(@song.name))
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
  end

  private
    def generate_html
      render template: "songs/print", layout: "pdf_layout", locals: { :song => @song }
    end

    def get_file_name(song_name)
      song_name + '.pdf'
    end
end
