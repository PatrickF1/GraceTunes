module SongUtils
  class BaseParsingStrategy; end
  class GracepointParsingStrategy < BaseParsingStrategy; end
  class SongSelectParsingStrategy < BaseParsingStrategy; end

  class SongNormalizer
    class UnsupportedFileType < StandardError; end

    SUPPORTED_MIME_TYPES = ['application', 'text', 'image']
    STRATEGIES = [
      ::SongUtils::GracepointParsingStrategy,
      ::SongUtils::SongSelectParsingStrategy,
      ::SongUtils::BaseParsingStrategy
    ]

    def initialize(path)
      @garbage_dir = File.expand_path('./tmp/file-conv-dump')
      @garbage_prefix = 'SNORMALIZER-'
      Dir.mkdir(@garbage_dir) unless Dir.exists?(@garbage_dir)

      raw_contents = text_for_file(File.expand_path(path))
      @strategy = parsing_strategy(path, raw_contents)
      @strategy.execute!

      cleanup_garbage
    end

    def normalized_song
      @strategy.song
    end

    private
    def text_for_file(path)
      text = ''

      mime_type = MIME::Types.type_for(path).first.try(:media_type)
      if !mime_type_supported?(mime_type)
        raise UnsupportedFileType.new("Mime type '#{mime_type}' is unsupported.")
      end

      case mime_type
      when 'application', 'text'
        ext = File.extname(path)
        case ext.downcase
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

      when 'image'
        text = Tesseract::Engine.new.text_for(path)
      else
        err = 'File extension is unknown or unsupported.'
        raise UnsupportedFileType.new(err)
      end

      text
    end

    def pdf_to_png(input_path)
      output_name = File.basename(input_path, File.extname(input_path)) << '.png'
      output_path = "#{@garbage_dir}/#{@garbage_prefix}#{output_name}"

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

    def parsing_strategy(filename, raw_text)
      matches = STRATEGIES.select { |strategy| strategy.match?(raw_text) }
      matches.first.new(File.basename(filename, '.*'), raw_text)
    end

    def cleanup_garbage
      FileUtils.rm(Dir.glob("#{@garbage_dir}/#{@garbage_prefix}*"))
    end
  end

  class BaseParsingStrategy
    attr_reader :song

    def self.match?(text)
      # Base class, always match it
      true
    end

    def initialize(filename, raw_text)
      @filename = filename
      @raw_text = raw_text
      @song = Song.new
    end

    def execute!
      parse_name
      parse_artist
      parse_key
      parse_tempo
      parse_sheet_music
    end

    protected
    # use the filename as the name
    def parse_name
      # remove stuff like (1) or (A) or - or _ in title
      name = @filename.gsub(/\([0-9]\)|\([A-Za-z]{1,2}\)/, '')
      # replace separators with spaces
      @song.name = name.gsub(/-|_/, ' ')
    end

    def parse_artist; end
    
    def parse_tempo; end

    def parse_key
      # try to strip key from the filename
      key_match = @filename.match(/\([A-Za-z]{1,2}\)|(?<=in )[A-Za-z]{1,2}(?=\.)/)
      if key_match && key_match[0].present?
        # remove surrounding parentheses
        key = key_match[0].gsub(/\(|\)/, '')
        key = key.upcase if key.length == 1
        @song.key = key
      end
    end

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
      super
      name_match = @raw_text.match(/(?<=Chordsheet)\s*[\w| |,]*/)

      # some GP sheets have 'Page 1 of 1' and the name gets set to 'Page'.
      # if that happens just fallback to the filename.
      if name_match.present? && name_match[0].present? && name_match[0].strip != 'Page'
        name = name_match[0].strip
        @song.name = name
      end
    end
  end

  class SongSelectParsingStrategy
    def self.match?(text)
      text.match(/SongSelect|Songselect/).present?
    end

    private
    def parse_name
      super
      name_match = @raw_text.match(/.*(?=Key)|(?=\n)/)

      if name_match && name_match[0].present?
        name = name_match[0].strip
        @song.name = name
      end
    end

    def parse_artist
      artist = nil
      artist_match = @raw_text.match(/(?<=Words and Music by)\s*[\w| ]*/)

      if artist_match && artist_match[0].present?
        artist = artist_match[0].strip
        @song.artist = artist
      end
    end

    def parse_key
      super
      key_match = @raw_text.match(/Key((\s*-\s*)|(-|\s*))\w{1,2}/)

      if key_match && key_match[0].present?
        key = key_match[0].gsub(/(Key|-)/, '').strip
        @song.key = key
      end
    end
  end
end
