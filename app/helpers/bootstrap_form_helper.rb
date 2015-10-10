module BootstrapFormHelper
  include ActionView::Helpers
  include PanelHelper

  mattr_accessor :layout
  FIELD_HELPERS = [:email_field, :password_field, :text_field, :text_area,
                   :search_field, :telephone_field, :url_field, :number_field,
                   :file_field, :date_field, :time_field, :month_field,
                   :week_field, :datetime_field]

  def form_for(record, options = {}, &block)
    html_options = options[:html] ||= {}

    prepend_class(html_options, get_form_layout(options.delete(:layout)))
    options[:html] = html_options

    super
  end

  # TODO: color_field, datetime_local_field, range_field

  FIELD_HELPERS.each do |helper|
    define_method helper do |object_name, method, options={}|
      label_class, field_wrapper = ['col-sm-3 control-label', true] if layout == :horizontal

      prepend_class(options, 'form-control') unless __callee__ == :file_field

      required        = 'required' if options.delete(:required)
      label_sr_only   = 'sr-only' if options[:label].is_a?(FalseClass)
      label_class     = squeeze_n_strip("#{label_class} #{required} #{label_sr_only}")
      help_text       = (options[:help] ? "<span class='help-block text-left'>#{options[:help]}</span>" : '').html_safe
      prefix_content  = options.delete(:prefix)
      suffix_content  = options.delete(:suffix)

      label_proc = proc { label(object_name, method, options[:label], class: label_class) }

      input_proc = proc do
        input_content = if prefix_content.present? || suffix_content.present?
                          prefix_addon = build_input_addon(prefix_content)
                          suffix_addon = build_input_addon(suffix_content)
                          content_tag :div, class: 'input-group' do
                            prefix_addon + super(object_name, method, options) + suffix_addon
                          end
                        else
                          super(object_name, method, options)
                        end

        input_content + help_text
      end

      render_field(field_wrapper, label_proc, input_proc)
    end

    def fields_for(record_name, record_object = nil, options = {}, &block)
      fieldset = HashWithIndifferentAccess.new(options.delete(:fieldset))

      if fieldset.present?
        type  = get_panel_type(fieldset[:type])
        title = fieldset[:title]
      end

      content_tag :fieldset, class: "panel #{type}" do
        ((title.present? ? (content_tag :div, title, class: 'panel-heading') : '') +
          (content_tag :div, class: 'panel-body' do
            super
          end)).html_safe
      end
    end

    alias_method :fieldset, :panel

    def build_input_addon(content)
      return ('').html_safe if content.blank?

      if content.is_a?(String)
        "<span class='input-group-addon'>#{content}</span>".html_safe
      elsif content.is_a?(Hash) && content.key?(:icon)
        "<span class='input-group-addon'>#{icon(content[:icon])}</span>".html_safe
      else
        ('').html_safe
      end
    end

    def render_field(inline_style, label_proc, input_proc)
      content_tag :div, class: 'form-group' do
        if inline_style
          (label_proc.call + (content_tag :div, class: 'col-sm-9', &input_proc)).html_safe
        else
          (label_proc.call + input_proc.call).html_safe
        end
      end
    end
  end

  class ActionView::Helpers::FormBuilder
    include BootstrapFormHelper
    include ButtonHelper

    attr_accessor :output_buffer

    def check_box(method, options = {}, checked_value = '1', unchecked_value = '0')
      layout_inline = options.delete(:layout).try(:to_sym) == :inline

      check_box = proc do
        proc = proc do
          @template.check_box(@object_name, method, objectify_options(options), checked_value, unchecked_value) +
            options[:label]
        end

        if layout_inline
          content_tag :label, class: 'checkbox-inline', &proc
        else
          content_tag :div, class: 'checkbox' do
            content_tag :label, &proc
          end
        end
      end

      if horizontal_layout?
        content_tag :div, class: 'form-group' do
          content_tag :div, class: 'col-sm-offset-3 col-sm-9', &check_box
        end
      else
        check_box.call
      end
    end

    def radio_button(method, tag_value, options = {})
      layout_inline = options.delete(:layout).try(:to_sym) == :inline

      radio_button = proc do
        proc = proc do
          @template.radio_button(@object_name, method, tag_value, objectify_options(options)) + options[:label]
        end

        if layout_inline
          content_tag :label, class: 'radio-inline', &proc
        else
          content_tag :div, class: 'radio' do
            content_tag :label, &proc
          end
        end
      end

      if horizontal_layout?
        content_tag :div, class: 'form-group' do
          content_tag :div, class: 'col-sm-offset-3 col-sm-9', &radio_button
        end
      else
        radio_button.call
      end
    end

    def submit(value=nil, options={})
      value, options = nil, value if value.is_a?(Hash)
      value ||= submit_default_value

      prepend_class(options, 'btn', get_btn_type(options.delete(:type)))

      submit_prc = proc { @template.submit_tag(value, options) }

      return submit_prc.call unless horizontal_layout?

      content_tag :div, class: 'form-group' do
        content_tag :div, class: 'col-sm-offset-3 col-sm-9', &submit_prc
      end
    end

    private

    def horizontal_layout?
      BootstrapFormHelper.layout == :horizontal
    end
  end

  private

  def get_form_layout(form_layout)
    case form_layout.try(:to_sym)
    when :horizontal
      layout = :horizontal
      'form form-horizontal'
    when :inline
      layout = :inline
      'form form-inline'
    else
      layout = :basic
      'form'
    end
  end
end
