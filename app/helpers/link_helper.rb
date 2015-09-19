module LinkHelper

  def navbar_link_to(name = nil, options = nil, html_options = nil, &block)
    html_options, options, name = options, name, block if block_given?
    options      ||= {}
    html_options ||= {}

    html_options[:class] = "navbar-link #{html_options[:class]}"

    if block_given?
      link_to options, html_options do
        yield name
      end
    else
      link_to name, options, html_options
    end
  end

  def navbar_brand(name = nil, options = nil, html_options = nil, &block)
    html_options, options, name = options, name, block if block_given?
    options      ||= {}
    html_options ||= {}

    html_options[:class] = "navbar-brand #{html_options[:class]}"

    if block_given?
      link_to options, html_options do
        yield name
      end
    else
      link_to name, options, html_options
    end
  end
end
