module ButtonHelper
  include ActionView::Helpers

  def button(content_or_options=nil, options={}, &block)
    content_or_options.is_a?(Hash) ? options = content_or_options : content = content_or_options

    klass  = options.delete(:class)
    layout = 'btn-block' if options.delete(:layout).try(:to_sym) == :block
    size   = case options.delete(:size).try(:to_sym)
               when :xsmall
                 'btn-xs'
               when :small
                 'btn-sm'
               when :large
                 'btn-lg'
               else
             end
    type   = case options.delete(:type).try(:to_sym)
               when :primary
                 'btn-primary'
               when :info
                 'btn-info'
               when :success
                 'btn-success'
               when :warning
                 'btn-warning'
               when :danger
                 'btn-danger'
               when :link
                 'btn-link'
               else
                 'btn-default'
             end

    klass = squeeze_n_strip("btn #{type} #{size} #{layout} #{klass}")

    content_tag :button, options.merge({class: klass}) do
      content.presence || capture(&block)
    end
  end

  def button_group(options={}, &block)
    size   = case options.delete(:size).try(:to_sym)
               when :xsmall
                 'btn-group-xs'
               when :small
                 'btn-group-sm'
               when :large
                 'btn-group-lg'
               else
             end
    layout = options.delete(:layout).try(:to_sym) == :vertical ? 'btn-group-vertical' : 'btn-group'

    options[:class] = squeeze_n_strip("#{layout} #{size} #{options[:class]}")
    options[:role]  = squeeze_n_strip("group #{options[:role]}")
    options[:data]  = (options[:data] || {}).merge({bvg: 'btn_group', size: size})

    content_tag :div, options do
      yield if block_given?
    end
  end

  def button_toolbar(options={}, &block)
    options[:class] = squeeze_n_strip("btn-toolbar #{options[:class]}")
    options[:role]  = squeeze_n_strip("toolbar #{options[:role]}")

    content_tag :div, options do
      yield if block_given?
    end
  end

end
