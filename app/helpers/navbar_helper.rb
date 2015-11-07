module NavbarHelper
  include ActionView::Helpers
  include FormatHelper

  # TODO: add navbar form support
  def navbar(options={}, &block)
    style                    = options.delete(:inverse).presence ? 'navbar navbar-inverse' : 'navbar navbar-default'
    container                = options.delete(:fluid).presence ? 'container-fluid' : 'container'
    padding                  = options.delete(:padding).presence || '70px'
    position, position_style = parse_position(options.delete(:position), padding)

    prepend_class(options, style, position)
    options.deep_merge!(data: {bui: 'navbar'})

    (position_style + (content_tag :nav, options do
      content_tag :div, class: container, &block
    end)).html_safe
  end

  def vertical(options={}, &block)
    prepend_class(options, 'navbar-header')

    btn_content = ("<span class='icon-bar'></span>" * 3).html_safe
    btn_options = {
      class: 'navbar-toggle collapsed',
      type:  :button,
      data:  {toggle: 'collapse'},
      aria:  {expanded: false}
    }

    content_tag :div, options do
      (content_tag :button, btn_content, btn_options) + capture(&block)
    end
  end

  def horizontal(options={}, &block)
    prepend_class(options, 'collapse navbar-collapse')

    content_tag :div, options, &block
  end

  def navbar_menu(options={}, &block)
    style = case options.delete(:position).try(:to_sym)
            when :right
              'nav navbar-nav navbar-right'
            when :left
              'nav navbar-nav navbar-left'
            else
              'nav navbar-nav'
            end

    prepend_class(options, style)
    content_tag :ul, options, &block
  end

  def navbar_link_to(name = nil, options = nil, html_options = nil, &block)
    html_options, options, name = options, name, block if block_given?
    options      ||= {}
    html_options ||= {}

    prepend_class(html_options, 'navbar-link')

    link_to options, html_options do
      block_given? ? (yield name) : name
    end
  end

  def navbar_link(name = nil, options = nil, html_options = nil, &block)
    html_options, options, name = options, name, block if block_given?
    options      ||= {}
    html_options ||= {}

    prepend_class(html_options, 'navbar-link')
    active = 'active' if html_options.delete(:active)


    content_tag :li, class: active do
      link_to options, html_options do
        block_given? ? (yield name) : name
      end
    end
  end

  def navbar_brand(name = nil, options = nil, html_options = nil, &block)
    html_options, options, name = options, name, block if block_given?
    options                     ||= {}
    html_options                ||= {}

    prepend_class(html_options, 'navbar-brand')

    link_to options, html_options do
      block_given? ? (yield name) : name
    end
  end

  def navbar_dropdown(content=nil, list=[], options={})
    dropdown(content, list, options.merge({category: :navbar}))
  end

  private

  def parse_position(position, padding)
    case position.try(:to_sym)
    when :static
      ['navbar-static-top', '']
    when :top
      ['navbar-fixed-top', "<style>body {padding-top: #{padding}}</style>"]
    when :bottom
      ['navbar-fixed-bottom', "<style>body {padding-bottom: #{padding}}</style>"]
    else
      ['', '']
    end
  end
end
