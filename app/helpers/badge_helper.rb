module BadgeHelper
  include FormatHelper

  def badge(content=nil, options={})
    return if content.blank?

    tag = options.delete(:tag).try(:to_sym).presence || :span
    prepend_class(options, 'badge')

    content_tag tag, content, options
  end
end
