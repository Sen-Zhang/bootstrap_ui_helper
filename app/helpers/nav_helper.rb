module NavHelper

  def nav(options={}, &block)
    nav_options = {
      as:     options.delete(:as).presence || :tabs,
      layout: options.delete(:layout).presence
    }

    tag    = options.delete(:tag).try(:to_sym).presence || :ul
    klass  = options.delete(:class)
    active = options.delete(:active)

    options.merge!(
      {
        class: "nav #{build_nav_class(nav_options)} #{klass}".squeeze(' ').strip,
        data: {active_element: active}
      }
    )

    content_tag tag, options do
      yield if block_given?
    end
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
