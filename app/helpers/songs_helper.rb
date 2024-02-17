# frozen_string_literal: true

module SongsHelper
  def get_tempo_opts(selected, include_any = false)
    options = Song::VALID_TEMPOS.map { |t| [t, t] }
    options.insert(0, ['Any', '']) if include_any
    options_for_select(options, selected:)
  end

  def get_key_opts(selected, include_any = false)
    options = Song::VALID_KEYS.map { |k| [k, k] }
    options.insert(0, ['Any', '']) if include_any
    options_for_select(options, selected:)
  end
end
