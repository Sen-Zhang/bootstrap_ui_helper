module NavbarHelper
  include ActionView::Helpers

  # TODO: add navbar form support
  def navbar(options={}, &block)
    style                    = options.delete(:inverted).presence ? 'navbar navbar-inverse' : 'navbar navbar-default'
    container                = options.delete(:fluid).presence ? 'container-fluid' : 'container'
    padding                  = options.delete(:padding).presence || '70px'
    position, position_style = case options.delete(:position).try(:to_sym)
                                 when :static
                                   ['navbar-static-top', '']
                                 when :top
                                   ['navbar-fixed-top', "<style>body {padding-top: #{padding}}</style>"]
                                 when :bottom
                                   ['navbar-fixed-bottom', "<style>body {padding-bottom: #{padding}}</style>"]
                                 else
                                   ['', '']
                               end

    options[:class] = squeeze_n_strip("#{style} #{position} #{options[:class]}")
    options[:data]  = (options[:data] || {}).merge({bvg: 'navbar'})

    (position_style + (content_tag :nav, options do
      content_tag :div, class: container do
        yield if block_given?
      end
    end)).html_safe
  end

  def vertical(options={}, &block)
    options[:class] = squeeze_n_strip("navbar-header #{options[:class]}")

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
    options[:class] = squeeze_n_strip("collapse navbar-collapse #{options[:class]}")

    content_tag :div, options do
      yield if block_given?
    end
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

    options[:class] = squeeze_n_strip("#{style} #{options[:class]}")

    content_tag :ul, options do
      yield if block_given?
    end
  end

end
