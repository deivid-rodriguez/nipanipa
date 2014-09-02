require 'yaml'

module I18nHelpers
  PLURALIZATION_KEYS = %w(
    zero
    one
    two
    few
    many
    other
  )

  def load_locales
    base_i18n_files.each do |file|
      locale = File.basename(File.dirname(file))
      hash = YAML.load_file(file)[locale]
      if locales_to_keys[locale]
        locales_to_keys[locale] += get_flat_keys(hash)
      else
        locales_to_keys[locale] = get_flat_keys(hash)
      end
    end
  end

  def base_i18n_files
    Dir['config/locales/**/*.yml'].delete_if { |f| File.basename(f, '.*') == 'defaults' }
  end

  def locales_to_keys
    @locales_to_keys ||= {}
  end

  def unique_keys
    locales_to_keys.values.flatten.uniq.sort
  end

  def get_flat_keys(hash, path = [])
    hash.map do |k, v|

      new_path = path + [k]

      # Ignore any pluralization differences.
      if v.is_a?(Hash) && looks_like_plural?(v)
        v = "Pretend it's a leaf."
      end

      case v
      when Hash
        get_flat_keys(v, new_path)
      when String
        new_path.join('.')
      else
        fail "wtf? #{ v }"
      end
    end.flatten
  end

  def looks_like_plural?(hash)
    hash.keys.length > 1 && hash.keys.all? { |k| PLURALIZATION_KEYS.include?(k) }
  end
end
