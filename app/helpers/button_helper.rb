module ButtonHelper
  include ActionView::Helpers
  include FormatHelper

  def button(content_or_options=nil, options={}, &block)
    content, options = parse_content_or_options(content_or_options, options)

    layout = 'btn-block' if options.delete(:layout).try(:to_sym) == :block
    size   = get_btn_size(options.delete(:size))
    type   = get_btn_type(options.delete(:type))
    prepend_class(options, 'btn', type, size, layout)

    content_tag :button, (content.presence || capture(&block)), options
  end

  def button_group(options={}, &block)
    size   = get_btn_group_size(options.delete(:size))
    layout = if options.delete(:layout).try(:to_sym) == :vertical
               'btn-group-vertical'
             else
               'btn-group'
             end

    prepend_class(options, layout, size)
    options[:role] = 'group'
    options[:data] = (options[:data] || {}).merge({bui: 'btn_group', size: size})

    content_tag :div, options, &block
  end

  def button_toolbar(options={}, &block)
    prepend_class(options, 'btn-toolbar')
    options[:role] = 'toolbar'

    content_tag :div, options, &block
  end

  def navbar_button(content_or_options=nil, options={}, &block)
    content, options = parse_content_or_options(content_or_options, options)

    prepend_class(options, 'navbar-btn')
    button content, options, &block
  end

  private

  def get_btn_size(size)
    case size.try(:to_sym)
    when :xsmall
      'btn-xs'
    when :small
      'btn-sm'
    when :large
      'btn-lg'
    else
    end
  end

  def get_btn_type(type)
    case type.try(:to_sym)
    when :primary
      'btn-primary'
    when :info
      'btn-info'
    when :success
      'btn-success'
    when :warning
      'btn-warning'
    when :danger
      'btn-danger'
    when :link
      'btn-link'
    else
      'btn-default'
    end
  end

  def get_btn_group_size(size)
    case size.try(:to_sym)
    when :xsmall
      'btn-group-xs'
    when :small
      'btn-group-sm'
    when :large
      'btn-group-lg'
    else
    end
  end
end
