module NavHelper

  class NavCreator
    include FormatHelper
    include ActionView::Helpers

    attr_accessor :options
    attr_accessor :output_buffer

    def initialize(options)
      @options = options
    end

    def render
      nav_options = {
        as:     options.delete(:as).presence || :tabs,
        layout: options.delete(:layout).presence
      }

      tag    = options.delete(:tag).try(:to_sym).presence || :ul
      active = options.delete(:active)

      prepend_class(options, 'nav', build_nav_class(nav_options))

      options.merge!(data: {bvg: 'nav', active_el_locator: active})

      [tag, options]
    end

    private
    def build_nav_class(options)
      as     = case options[:as].try(:to_sym)
                 when :tabs
                   'nav-tabs'
                 when :pills
                   'nav-pills'
                 else
               end
      layout = case options[:layout].try(:to_sym)
                 when :stacked
                   'nav-stacked'
                 when :justified
                   'nav-justified'
                 else
               end

      "#{as} #{layout}"
    end
  end

  def nav(options={}, &block)
    tag, options = NavCreator.new(options).render

    content_tag tag, options, &block
  end
end
