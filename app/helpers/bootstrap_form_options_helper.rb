module BootstrapFormOptionsHelper

  class ActionView::Helpers::FormBuilder
    include FormatHelper
    include BootstrapFormHelper


    def select(method, choices = nil, options = {}, html_options = {}, &block)
      label_class, field_wrapper = horizontal_layout? ? ['col-sm-3 control-label', true] : []

      required = 'required' if html_options.delete(:required)
      label_sr_only = 'sr-only' if html_options[:label].is_a?(FalseClass)
      html_options[:class] = squeeze_n_strip("form-control #{html_options[:class]}")
      label_class = squeeze_n_strip("#{label_class} #{required} #{label_sr_only}")
      help_text = (html_options[:help] ? "<span class='help-block text-left'>#{html_options[:help]}</span>" : '').html_safe

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

    def collection_check_boxes(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
      check_boxes_proc = Proc.new do
        @template.collection_check_boxes(@object_name, method, collection, value_method, text_method,
                                         objectify_options(options), @default_options.merge(html_options),
                                         &block)
      end

      render_collection(options[:label], &check_boxes_proc)
    end

    def collection_radio_buttons(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
      radion_buttons_prc = Proc.new do
        @template.collection_radio_buttons(@object_name, method, collection, value_method, text_method,
                                           objectify_options(options), @default_options.merge(html_options),
                                           &block)
      end

      render_collection(options[:label], &radion_buttons_prc)
    end

    private

    def render_label(label)
      label_class = 'col-sm-3 control-label' if horizontal_layout?

      label.present? ? "<label class='#{label_class}'>#{label}</label>  " : ''
    end

    def render_input(&input_block)
      horizontal_layout? ? (content_tag :div, class: 'col-sm-9', &input_block) : yield
    end

    def render_collection(label, &input_block)
      content_tag :div, class: 'form-group' do
        (render_label(label) + render_input(&input_block)).html_safe
      end
    end

    def horizontal_layout?
      BootstrapFormHelper.layout == :horizontal
    end
  end

  class ActionView::Helpers::Tags::CollectionCheckBoxes
    attr_accessor :output_buffer

    def render(&block)
      rendered_collection = render_collection do |item, value, text, default_html_options|
        default_html_options[:multiple] = true
        builder = instantiate_builder(CheckBoxBuilder, item, value, text, default_html_options)

        if block_given?
          @template_object.capture(builder, &block)
        else
          render_check_box(builder, @options.fetch(:inline, false))
        end
      end

      if @options.fetch(:include_hidden, true)
        rendered_collection + hidden_field
      else
        rendered_collection
      end
    end

    private

    def render_check_box(builder, inline=false)
      label_class, input_wrapper = 'checkbox-inline', true if inline

      input_proc = Proc.new do
        content_tag :label, class: label_class do
          builder.check_box + ' ' + builder.text
        end
      end

      input_wrapper ? input_proc.call : (content_tag :div, class: 'checkbox', &input_proc)
    end
  end

  class ActionView::Helpers::Tags::CollectionRadioButtons
    attr_accessor :output_buffer

    def render(&block)
      render_collection do |item, value, text, default_html_options|
        builder = instantiate_builder(RadioButtonBuilder, item, value, text, default_html_options)

        if block_given?
          @template_object.capture(builder, &block)
        else
          render_radio_button(builder, @options.fetch(:inline, false))
        end
      end
    end

    private

    def render_radio_button(builder, inline=false)
      label_class, input_wrapper = 'radio-inline', true if inline

      input_proc = Proc.new do
        content_tag :label, class: label_class do
          builder.radio_button + ' ' + builder.text
        end
      end

      input_wrapper ? input_proc.call : (content_tag :div, class: 'radio', &input_proc)
    end
  end

end
