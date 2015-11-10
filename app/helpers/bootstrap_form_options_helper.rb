module BootstrapFormOptionsHelper

  class ActionView::Helpers::FormBuilder
    include FormatHelper
    include BootstrapFormHelper

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      label_class, field_wrapper = horizontal_layout? ? ['col-sm-3 control-label', true] : []

      required      = 'required' if options.delete(:required)
      label_sr_only = 'sr-only' if options[:label].is_a?(FalseClass) || layout == :inline
      label_class   = squeeze_n_strip("#{label_class} #{required} #{label_sr_only}")
      help_text     = render_help_text(options.delete(:help))

      prepend_class(html_options, 'form-control')
      select_proc = proc do
        @template.select(@object_name,
                         method,
                         choices,
                         objectify_options(options),
                         @default_options.merge(html_options),
                         &block) + help_text
      end
      label_proc  = proc { label(method, options.delete(:label), class: label_class) }

      render_field(field_wrapper, label_proc, select_proc)
    end

    def collection_check_boxes(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
      check_boxes_proc = proc do
        @template.collection_check_boxes(@object_name,
                                         method,
                                         collection,
                                         value_method,
                                         text_method,
                                         objectify_options(options),
                                         @default_options.merge(html_options),
                                         &block)
      end

      render_collection(options.delete(:label), &check_boxes_proc)
    end

    def collection_radio_buttons(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
      radio_buttons_proc = proc do
        @template.collection_radio_buttons(@object_name,
                                           method,
                                           collection,
                                           value_method,
                                           text_method,
                                           objectify_options(options),
                                           @default_options.merge(html_options),
                                           &block)
      end

      render_collection(options.delete(:label), &radio_buttons_proc)
    end

    private

    def render_label(label)
      label_class = horizontal_layout? ? 'col-sm-3 control-label' : ''
      label_class += ' sr-only' if label.blank?

      rendered_label = ("<label class='#{label_class}'>#{label}</label>  ").html_safe
      basic_layout? ? content_tag(:div, rendered_label) : rendered_label
    end

    def render_input(&input_block)
      horizontal_layout? ? (content_tag :div, class: 'col-sm-9', &input_block) : yield
    end

    def render_collection(label, &input_block)
      content_tag :div, class: 'form-group' do
        (render_label(label) + render_input(&input_block)).html_safe
      end
    end

    def basic_layout?
      BootstrapFormHelper.layout == :basic
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
        builder                         = instantiate_builder(CheckBoxBuilder, item, value, text, default_html_options)

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

      input_proc = proc do
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

      input_proc = proc do
        content_tag :label, class: label_class do
          builder.radio_button + ' ' + builder.text
        end
      end

      input_wrapper ? input_proc.call : (content_tag :div, class: 'radio', &input_proc)
    end
  end

end
