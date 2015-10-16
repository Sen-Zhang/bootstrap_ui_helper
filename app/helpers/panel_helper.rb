module PanelHelper
  include ActionView::Helpers

  def panel(options={}, &block)
    tag  = options.delete(:tag).try(:to_sym) || :div
    type = get_panel_type(options.delete(:type))

    prepend_class(options, 'panel', type)

    content_tag tag, options, &block
  end

  %w(heading title body footer).each do |part|
    define_method "panel_#{part}" do |content_or_options=nil, options={}, &block|
      content_or_options.is_a?(Hash) ? options = content_or_options : content = content_or_options

      tag = options.delete(:tag).try(:to_sym) || (part == 'title' ? :h3 : :div)

      prepend_class(options, "panel-#{part}")

      content_tag tag, content || capture(&block), options
    end
  end

  private

  def get_panel_type(type)
    case type.try(:to_sym)
    when :primary
      'panel-primary'
    when :info
      'panel-info'
    when :success
      'panel-success'
    when :warning
      'panel-warning'
    when :danger
      'panel-danger'
    else
      'panel-default'
    end
  end
end
