module ProgressBarHelper

  def progress_bar(bars_or_options=nil, options={})
    bars = bars_or_options.is_a?(Hash) ? [bars_or_options] : bars_or_options

    options[:class] = squeeze_n_strip("progress #{options[:class]}")

    content_tag :div, options do
      bars.map { |bar| build_bar(bar) }.join('').html_safe
    end

  end

  private
  def process_progress_bar_options(options={})
    percentage     = options.delete(:percentage) || 0
    label          = options.delete(:label)
    striped        = options.delete(:striped).presence
    animated       = options.delete(:animated).presence
    original_class = options.delete(:class) || ''
    klass          = case options.delete(:type).try(:to_sym)
                       when :info
                         'progress-bar progress-bar-info'
                       when :success
                         'progress-bar progress-bar-success'
                       when :warning
                         'progress-bar progress-bar-warning'
                       when :danger
                         'progress-bar progress-bar-danger'
                       else
                         'progress-bar'
                     end

    unless label.is_a?(String)
      label = label.is_a?(TrueClass) ? "#{percentage}%" : nil
    end

    if animated
      klass += ' progress-bar-striped active'
    elsif striped
      klass += ' progress-bar-striped'
    end

    klass += original_class

    [percentage, label, klass]
  end

  def build_bar(options={})
    percentage, label, klass = process_progress_bar_options(options)
    style                    = "width: #{percentage}%"

    content_tag :div,
                class: klass,
                style: style,
                role: 'progressbar',
                aria: {valuemax: 100, valuemin: 0, valuenow: percentage} do
      label.present? ? label : (content_tag :span, label, class: 'sr-only')
    end
  end

end
