module LabelHelper
  include FormatHelper

  def label_bvg(content=nil, options={})
    return if content.blank?

    tag   = options.delete(:tag).try(:to_sym).presence || :span
    klass = get_label_type(options.delete(:type))

    prepend_class(options, 'label', klass)

    content_tag tag, content, options
  end

  private

  def get_label_type(type)
    case type.try(:to_sym)
      when :default
        'label-default'
      when :primary
        'label-primary'
      when :success
        'label-success'
      when :info
        'label-info'
      when :warning
        'label-warning'
      when :danger
        'label-danger'
      else
        'label-default'
    end
  end
end