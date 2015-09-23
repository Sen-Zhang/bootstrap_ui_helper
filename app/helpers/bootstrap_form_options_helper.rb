module BootstrapFormOptionsHelper

  class ActionView::Helpers::FormBuilder
    include FormatHelper

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      label_class, field_wrapper = horizontal_layout? ? ['col-sm-3 control-label', true] : []

      required             = 'required' if html_options.delete(:required)
      label_sr_only        = 'sr-only' if html_options[:label].is_a?(FalseClass)
      html_options[:class] = squeeze_n_strip("form-control #{html_options[:class]}")
      label_class          = squeeze_n_strip("#{label_class} #{required} #{label_sr_only}")
      help_text            = (html_options[:help] ? "<span class='help-block text-left'>#{html_options[:help]}</span>" : '').html_safe

      select_proc = Proc.new do
        @template.select(@object_name,
                         method,
                         choices,
                         objectify_options(options),
                         @default_options.merge(html_options),
                         &block) + help_text
      end

      label_proc = Proc.new { label(method, html_options[:label], class: label_class) }

      render_field(field_wrapper, label_proc, select_proc)
    end
  end

end
