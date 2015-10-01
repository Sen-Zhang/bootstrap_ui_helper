module AlertBoxHelper
  include ActionView::Helpers

  def alert_box(content_or_options=nil, options={}, &block)
    if content_or_options.is_a?(Hash)
      options = content_or_options
    else
      content = content_or_options
    end

    dismissible = options.delete(:dismiss).present?
    klass       = options.delete(:class)
    type        = alert_type(options.delete(:type))

    prepend_class(options, 'alert', type, klass)
    options[:role] = 'alert'

    render_alert_box(options, dismissible, content, &block)
  end

  def alert_type(type)
    case type.try(:to_sym)
      when :info
        'alert-info'
      when :success
        'alert-success'
      when :warning
        'alert-warning'
      when :danger
        'alert-danger'
      else
        'alert-info'
    end
  end

  def dismiss_button
    "<button type='button' class='close' data-dismiss='alert'" \
    "aria-label='Close'><span aria-hidden='true'>&times;</span></button>"
  end

  def render_alert_box(options, dismissible, content, &block)
    content_tag :div, options do
      if dismissible
        (dismiss_button + (content.presence || capture(&block))).html_safe
      else
        content.presence || capture(&block)
      end
    end
  end
end
