module LabelHelper
  include FormatHelper

  def label_bui(content=nil, options={})
    return if content.blank?

    tag   = options.delete(:tag).try(:to_sym).presence || :span

    prepend_class(options, 'label', get_label_type(options.delete(:type)))

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