module ButtonToHelper

  def button_to(name = nil, options = nil, html_options = nil, &block)
    html_options, options = options, name if block_given?
    options      ||= {}
    html_options ||= {}

    klass  = html_options.delete(:class)
    layout = 'btn-block' if html_options.delete(:layout).try(:to_sym) == :block
    size   = case html_options.delete(:size).try(:to_sym)
               when :xsmall
                 'btn-xs'
               when :small
                 'btn-sm'
               when :large
                 'btn-lg'
               else
             end
    style  = case html_options.delete(:style).try(:to_sym)
               when :primary
                 'btn btn-primary'
               when :info
                 'btn btn-info'
               when :success
                 'btn btn-success'
               when :warning
                 'btn btn-warning'
               when :danger
                 'btn btn-danger'
               when :link
                 'btn btn-link'
               else
                 'btn btn-default'
             end

    html_options.merge!({class: squeeze_n_strip("#{style} #{layout} #{size} #{klass}")})

    super(name, options, html_options, &block)
  end
end
