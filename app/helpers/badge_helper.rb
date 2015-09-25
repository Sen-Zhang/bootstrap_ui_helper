module BadgeHelper
  def badge(content=nil, options={})
    return if content.blank?

    tag             = options.delete(:tag).try(:to_sym).presence || :span
    options[:class] = squeeze_n_strip("badge #{options[:class]}")

    content_tag tag, content, options
  end
end
