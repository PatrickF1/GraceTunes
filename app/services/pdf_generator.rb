module PdfGenerator
  PDF_CONFIG = {
    zoom: 6,
    margin: {
      left: 1
    }
  }
  FOLDER_PATH = "app/assets/pdf"

  def self.generate_pdf(song)
    pdf = WickedPdf.new.pdf_from_string(generate_html(song), PDF_CONFIG)
    save_path = Rails.root.join(FOLDER_PATH, get_file_name(song.name))
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
  end

  def self.generate_html(song)
    ApplicationController.render( template: "songs/print", layout: "pdf_layout", assigns: { song: song})
  end

  def self.get_file_name(song_name)
    song_name + '.pdf'
  end

end
