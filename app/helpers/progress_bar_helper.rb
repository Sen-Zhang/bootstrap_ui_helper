module ProgressBarHelper

  class ProgressBarCreator
    include FormatHelper
    include ActionView::Helpers

    attr_accessor :options
    attr_accessor :output_buffer

    def initialize(options)
      @options = options
    end

    def render
      percentage, label = process_progress_bar_options
      options[:style]   = "width: #{percentage}%"
      options[:role]    = 'progressbar'
      options[:aria]    = {valuemax: 100, valuemin: 0, valuenow: percentage}

      content_tag :div, label, options
    end

    private
    def process_progress_bar_options
      percentage     = options.delete(:percentage) || 0
      label          = options.delete(:label)
      striped        = options.delete(:striped).presence
      animated       = options.delete(:animated).presence
      type           = get_progress_bar_type

      prepend_class(options, 'progress-bar', type)

      unless label.is_a?(String)
        label = label.is_a?(TrueClass) ? "#{percentage}%" : nil
      end

      if animated
        prepend_class(options, 'progress-bar-striped active')
      elsif striped
        prepend_class(options, 'progress-bar-striped')
      end

      [percentage, label]
    end

    def get_progress_bar_type
      case options.delete(:type).try(:to_sym)
      when :info
        'progress-bar-info'
      when :success
        'progress-bar-success'
      when :warning
        'progress-bar-warning'
      when :danger
        'progress-bar-danger'
      else
      end
    end
  end

  def progress_bar(bars_or_options=nil, options={})
    bars = bars_or_options.is_a?(Hash) ? [bars_or_options] : bars_or_options

    prepend_class(options, 'progress')

    content_tag :div, options do
      bars.map { |bar| ProgressBarCreator.new(bar).render }.join('').html_safe
    end
  end
end
