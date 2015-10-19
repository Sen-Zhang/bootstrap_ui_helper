module FormatHelper

  def squeeze_n_strip(string='')
    string.squeeze(' ').strip
  end

  def prepend_class(options, *attrs)
    options[:class] = squeeze_n_strip("#{attrs.join(' ')} #{options[:class]}")
  end

  def parse_content_or_options(content_or_options, options)
    if content_or_options.is_a?(Hash)
      [nil, content_or_options]
    else
      [content_or_options, options]
    end
  end
end
