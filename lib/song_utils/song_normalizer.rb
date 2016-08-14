
module SongUtils
  class ParsingStrategy; end
  class GracepointParsingStrategy < ParsingStrategy; end
  class SongSelectParsingStrategy < ParsingStrategy; end

  class SongNormalizer
    class UnsupportedFileType < StandardError; end
    class UnsupportedLayout < StandardError; end

    attr_reader :raw_contents

    SUPPORTED_MIME_TYPES = ['application', 'image']
    STRATEGIES = [
      ::SongUtils::GracepointParsingStrategy,
      ::SongUtils::SongSelectParsingStrategy
    ]

    def initialize(path, garbage_dir='./tmp')
      @garbage_dir = File.expand_path(garbage_dir)
      Dir.mkdir(@garbage_dir) unless Dir.exists?(@garbage_dir)

      @raw_contents = text_for_file(path)
      @strategy = parsing_strategy(@raw_contents)

      @strategy.execute!
    end

    def normalized_song
      @strategy.song
    end

    def self.bacon
      fn = File.expand_path("~/Downloads/Worship Resources/By His Wounds.pdf")
      self.new(fn)
    end

    private
    def text_for_file(path)
      text = ''

      mime_type = MIME::Types.type_for(path).first.try(:media_type)
      if !mime_type_supported?(mime_type)
        raise UnsupportedFileType.new("The #{mime_type} is unsupported.")
      end

      if mime_type == 'application'
        ext = File.extname(path)
        case ext
        when '.pdf'
          text = Yomu.new(path).text
          if text.blank?
            # This can happen when a PDF is only a scan and not actually text.
            # Try converting it to an image and use an OCR lib to parse instead.
            converted_path = pdf_to_png(path)
            text = Tesseract::Engine.new.text_for(converted_path)
          end
        when '.doc', '.docx', '.pages', '.txt', '.rtf'
          text = Yomu.new(path).text
        else
          err = "#{ext} files are not supported at this time."
          raise UnsupportedFileType.new(err)
        end

      elsif mime_type == 'image'
        text = Tesseract::Engine.new.text_for(path)
      else
        err = 'File extension is unknown or unsupported.'
        raise UnsupportedFileType.new(err)
      end

      text
    end

    def pdf_to_png(input_path)
      output_name = File.basename(input_path, File.extname(input_path)) << '.png'
      output_path = "#{@garbage_dir}/#{output_name}"

      MiniMagick::Tool::Convert.new do |convert|
        convert.density(300)
        convert.append
        convert << input_path
        convert.quality(85)
        convert << output_path
      end

      output_path
    end

    def mime_type_supported?(mime_type)
      SUPPORTED_MIME_TYPES.include?(mime_type)
    end

    def parsing_strategy(raw_text)
      matches = STRATEGIES.select { |strategy| strategy.match?(raw_text) }
      raise UnsupportedLayout.new('Unknown sheet layout.') if matches.empty?

      matches.first.new(raw_text)
    end
  end

  class ParsingStrategy
    attr_reader :song

    def self.match?(text)
      # Base class, never match it
      false
    end

    def initialize(raw_text)
      @song = Song.new
      @raw_text = raw_text
    end

    def execute!
      parse_name
      parse_artist
      parse_key
      parse_sheet_music
    end

    protected
    def parse_name; end
    def parse_artist; end
    def parse_key; end
    def parse_sheet_music
      @song.song_sheet = @raw_text
    end
  end

  class GracepointParsingStrategy
    def self.match?(text)
      text.match(/Gracepoint/).present?
    end

    private
    def parse_name
      name = ''
      match_name = @raw_text.match(/(?<=Chordsheet)\s*[\w| ]*/)
      name = match_name[0].strip if match_name

      @song.name = name
    end
  end

  class SongSelectParsingStrategy
    def self.match?(text)
      text.match(/SongSelect|Songselect/).present?
    end

    private
    def parse_name
      name = ''
      match_name = @raw_text.match(/.*(?=Key)|(?=\n)/)
      name = match_name[0].strip if match_name.present?

      @song.name = name
    end

    def parse_artist
      artist = ''
      match_artist = @raw_text.match(/(?<=Words and Music by)\s*[\w| ]*/)
      artist = match_artist[0].strip if match_artist.present?

      @song.artist = artist
    end

    def parse_key
      key = ''
      match_key = @raw_text.match(/Key((\s*-\s*)|(-|\s*))\w{1,2}/)

      if match_key.present?
        match = match_key[0]
        key = match.gsub(/(Key|-)/, '').strip
      end

      @song.key = key
    end
  end

end
