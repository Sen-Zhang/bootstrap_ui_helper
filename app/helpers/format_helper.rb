module FormatHelper

  def squeeze_n_strip(string='')
    string.squeeze(' ').strip
  end

  def prepend_class(options, *attrs)
    options[:class] = squeeze_n_strip("#{attrs.join(' ')} #{options[:class]}")
  end
end
