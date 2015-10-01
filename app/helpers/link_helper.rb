module LinkHelper
  include FormatHelper

  def navbar_link_to(name = nil, options = nil, html_options = nil, &block)
    html_options, options, name = options, name, block if block_given?
    options      ||= {}
    html_options ||= {}

    prepend_class(html_options, 'navbar-link')

    return link_to(name, options, html_options) unless block_given?

    link_to options, html_options do
      yield name
    end
  end

  def navbar_link(name = nil, options = nil, html_options = nil, &block)
    html_options, options, name = options, name, block if block_given?
    options      ||= {}
    html_options ||= {}

    prepend_class(html_options, 'navbar-link')
    active = 'active' if html_options.delete(:active)


    content_tag :li, class: active do
      if block_given?
        link_to options, html_options do
          yield name
        end
      else
        link_to name, options, html_options
      end
    end
  end

  def navbar_brand(name = nil, options = nil, html_options = nil, &block)
    html_options, options, name = options, name, block if block_given?
    options      ||= {}
    html_options ||= {}

    prepend_class(html_options, 'navbar-brand')

    if block_given?
      link_to options, html_options do
        yield name
      end
    else
      link_to name, options, html_options
    end
  end
end
