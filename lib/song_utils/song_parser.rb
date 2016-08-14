module SongUtils
  class SongNormalizer
    class UnsupportedFileType < StandardError; end
    class UnsupportedLayout < StandardError; end

    attr_reader :raw_contents

    SUPPORTED_MIME_TYPES = ['application', 'image']
    STRATEGIES = []

    def initialize(path, garbage_dir='./tmp')
      @garbage_dir = garbage_dir
      Dir.mkdir(@garbage_dir) unless Dir.exists?(@garbage_dir)

      @raw_contents = text_for_file(path)
      @strategy = parsing_strategy(@raw_contents)
      @strategy.execute!
    end

    def normalized_song
      @strategy.song
    end

    private
    def text_for_file(path)
      text = ''

      mime_type = MIME::Types.type_for(path).first.try(:media_type)
      if !mime_type_supported?(mime_type)
        raise ::UnsupportedFileType.new("The #{mime_type} is unsupported.")
      end

      if mime_type == 'application'
        ext = File.extname(path)
        case ext
        when '.pdf'
          text = Yomu.new(path).text
          if text.blank?
            converted_path = pdf_to_png(path)
            text = Tesseract::Engine.new.text_for(path)
          end
        when '.doc', '.docx', '.pages', '.txt', '.rtf'
          text = Yomu.new(path).text
        else
          err = "#{ext} files are not supported at this time."
          raise ::UnsupportedFileType.new(err)
        end

      elsif mime_type == 'image'
        text = Tesseract::Engine.new.text_for(path)
      else
        err = 'File extension is unknown or unsupported.'
        raise ::UnsupportedFileType.new(err)
      end

      text
    end

    def pdf_to_png(input_path)
      output_path = File.basename(input_path, File.extname(input_path)) << '.png'

      MiniMagick::Tool::Convert.new do |convert|
        convert.density(96)
        convert << input_path
        convert.quality(85)
        convert << output_path
      end

      "#{@garbage_dir}/output_path"
    end

    def mime_type_supported?(mime_type)
      SUPPORTED_MIME_TYPES.include?(mime_type)
    end

    def parsing_strategy(raw_text)
      matches = STRATEGIES.select { |strategy| strategy.match?(raw_text) }
      raise ::UnsupportedLayout.new('Unknown sheet layout.') if matches.empty?

      matches.first.new
    end
  end

  # ---- Parsing Strategies ---- #

  class ParsingStrategy
    attr_reader :song

    def initialize(raw_text)
      @song = Song.new
    end

    def execute!
      parse_title
      parse_artist
      parse_key
      parse_sheet_music
    end

    private
    def parse_title; end
    def parse_artist; end
    def parse_key; end
    def parse_sheet_music; end
  end
end
