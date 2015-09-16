module BadgeHelper

  def badge(content=nil, options={})
    return if content.blank?

    tag   = options.delete(:tag).try(:to_sym).presence || :span
    klass = options.delete(:class)

    options.merge!({class: "badge #{klass}".squeeze(' ').strip})

    content_tag tag, content, options
  end
end