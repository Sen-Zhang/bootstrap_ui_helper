module ModalHelper
  include ActionView::Helpers
  include FormatHelper

  def modal(options={}, &block)
    caption,
    button_options,
    modal_dialog_options,
    modal_content_options = parse_modal_options(options)

    ((button caption, button_options) +
      (content_tag :div, options do
        content_tag :div, modal_dialog_options do
          content_tag :div, modal_content_options, &block
        end
      end)).html_safe
  end

  def modal_header(content_or_options=nil, options={}, &block)
    content, options = parse_content_or_options(content_or_options, options)

    title_options = options.delete(:title_html) || {}
    prepend_class(options, 'modal-header')

    header_proc = block_given? ? block : proc { modal_title(content, title_options) }

    content_tag :div, options do
      render_close_btn + capture(&header_proc)
    end
  end

  %w(title body footer).each do |part|
    define_method "modal_#{part}" do |content_or_options=nil, options={}, &block|
      content, options = parse_content_or_options(content_or_options, options)
      tag              = part == 'title' ? options.delete(:tag).try(:to_sym) || :h4 : :div

      prepend_class(options, "modal-#{part}")

      content_tag tag, (content.presence || capture(&block)), options
    end
  end

  private

  def parse_modal_options(options)
    button_options        = options.delete(:button_html) || {}
    modal_dialog_options  = options.delete(:modal_dialog_html) || {}
    modal_content_options = options.delete(:modal_content_html) || {}
    caption               = button_options.delete(:caption) || 'Modal'
    modal_id              = options[:id] || "modal-#{SecureRandom.hex(3)}"
    button_options[:data] = (button_options[:data] || {}).merge({toggle: 'modal', target: "##{modal_id}"})
    size                  = get_modal_size(options.delete(:size).try(:to_sym))

    prepend_class(options, 'modal', 'fade')
    prepend_class(modal_dialog_options, 'modal-dialog', size)
    prepend_class(modal_content_options, 'modal-content')

    options.deep_merge!({id: modal_id, tabindex: -1, role: 'dialog', aria: {hidden: true}})

    [caption, button_options, modal_dialog_options, modal_content_options]
  end

  def get_modal_size(size)
    case size
    when :small
      'modal-sm'
    when :large
      'modal-lg'
    else
    end
  end

  def render_close_btn
    content_tag :button, type: :button, class: 'close', data: {dismiss: 'modal'} do
      content_tag :span, 'x', aria: {hidden: true}
    end
  end
end
