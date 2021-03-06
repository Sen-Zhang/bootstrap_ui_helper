module ButtonToHelper
  include FormatHelper

  def button_to(name = nil, options = nil, html_options = nil, &block)
    html_options, options = options, name if block_given?
    options      ||= {}
    html_options ||= {}

    layout = 'btn-block' if html_options.delete(:layout).try(:to_sym) == :block
    size   = get_btn_size(html_options.delete(:size))
    style  = get_btn_type(html_options.delete(:style))

    prepend_class(html_options, 'btn', style, layout, size)

    super(name, options, html_options, &block)
  end
end
