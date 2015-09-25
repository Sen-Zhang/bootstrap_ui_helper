module BreadcrumbHelper
  def breadcrumb(links=[], options={})
    return if links.blank?

    options[:class] = squeeze_n_strip("breadcrumb #{options[:class]}")

    content_tag :ol, options do
      (links.map.with_index { |link, index| render_li(link, (index == links.length - 1)) })
        .join('').html_safe
    end
  end

  def render_li(link, last_li)
    active = {class: 'active'} if last_li

    content_tag :li, active do
      last_li ? link.delete(:text) : (link_to link.delete(:text), link.delete(:link), link)
    end
  end
end
