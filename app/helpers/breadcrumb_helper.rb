module BreadcrumbHelper
  include FormatHelper

  def breadcrumb(links=[], options={})
    return if links.blank?

    prepend_class(options, 'breadcrumb')

    content_tag :ol, options do
      links.map.with_index do |link, index|
        render_li(link, (index == links.length - 1))
      end.join('').html_safe
    end
  end

  def render_li(link, last_li)
    active = {class: 'active'} if last_li

    content_tag :li, active do
      last_li ? link[:text] : (link_to link.delete(:text), link.delete(:link), link)
    end
  end
end
