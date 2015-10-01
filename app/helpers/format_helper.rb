module FormatHelper

  def squeeze_n_strip(string='')
    string.squeeze(' ').strip
  end

  %w(class role).each do |attr|
    define_method "prepend_#{attr}" do |options={}, *attrs|
      options[attr.to_sym] = squeeze_n_strip("#{attrs.join(' ')} #{options[attr.to_sym]}")
    end
  end
end
