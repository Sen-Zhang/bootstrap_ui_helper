module BreadcrumbHelper

  def breadcrumb(links=[], options={})
    return if links.blank?

    options[:class] = squeeze_n_strip("breadcrumb #{options[:class]}")

    content_tag :ol, options do
      (links.map.with_index do |link, index|
        active = index == links.length-1 ? {class: 'active'} : {}

        content_tag :li, active do
          active.present? ? link.delete(:text) : (link_to link.delete(:text), link.delete(:link), link)
        end
      end).join('').html_safe
    end
  end

end
