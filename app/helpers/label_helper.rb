module LabelHelper

  def label_bvg(content=nil, options={})
    return if content.blank?

    tag   = options.delete(:tag).try(:to_sym).presence || :span
    type  = options.delete(:type).try(:to_sym).presence || :default
    klass = options.delete(:class)

    label_class = case type
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
                  end

    options.merge!({class: "label #{label_class} #{klass}".squeeze(' ').strip})

    content_tag tag, content, options
  end
end