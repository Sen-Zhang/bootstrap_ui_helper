module NavbarHelper
  include ActionView::Helpers

  # TODO: add navbar form support
  def navbar(options={}, &block)
    style                    = options.delete(:inverse).presence ? 'navbar navbar-inverse' : 'navbar navbar-default'
    container                = options.delete(:fluid).presence ? 'container-fluid' : 'container'
    padding                  = options.delete(:padding).presence || '70px'
    position, position_style = parse_position(options.delete(:position), padding)

    prepend_class(options, style, position)

    options[:data] = (options[:data] || {}).merge(bvg: 'navbar')

    (position_style + (content_tag :nav, options do
      content_tag :div, class: container, &block
    end)).html_safe
  end

  def vertical(options={}, &block)
    prepend_class(options, 'navbar-header')

    content_tag :div, options do
      (content_tag :button,
                   class: 'navbar-toggle collapsed',
                   type: :button,
                   data: {toggle: 'collapse'},
                   aria: {expanded: false} do
        ("<span class='icon-bar'></span>" * 3).html_safe
      end) + capture(&block)
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
