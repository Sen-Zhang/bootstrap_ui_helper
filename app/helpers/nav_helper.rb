module NavHelper

  class NavCreator
    include FormatHelper
    include ActionView::Helpers

    attr_accessor :options
    attr_accessor :output_buffer

    def initialize(options)
      @options = options
    end

    def build
      nav_options = {
        as:     options.delete(:as).presence || :tabs,
        layout: options.delete(:layout).presence
      }

      tag    = options.delete(:tag).try(:to_sym).presence || :ul
      klass  = options.delete(:class)
      active = options.delete(:active)

      options.merge!(
        {
          class: squeeze_n_strip("nav #{build_nav_class(nav_options)} #{klass}"),
          data: {bvg: 'nav', active_el_locator: active}
        }
      )

      [tag, options]
    end

    private
    def build_nav_class(options)
      as     = case options[:as]
                 when 'tabs', :tabs
                   'nav-tabs'
                 when 'pills', :pills
                   'nav-pills'
                 else
               end
      layout = case options[:layout]
                 when 'stacked', :stacked
                   'nav-stacked'
                 when 'justified', :justified
                   'nav-justified'
                 else
               end

      "#{as} #{layout}"
    end
  end

  def nav(options={}, &block)
    tag, options = NavCreator.new(options).build

    content_tag tag, options do
      yield if block_given?
    end
  end
end
