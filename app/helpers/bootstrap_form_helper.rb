module BootstrapFormHelper
  include ActionView::Helpers

  mattr_accessor :layout
  @@field_helpers = [:email_field, :password_field, :text_field, :text_area, :search_field, :telephone_field,
                     :url_field, :number_field]

  def form_for(record, options = {}, &block)
    html_options = options[:html] ||= {}

    form_layout = case options.delete(:layout).try(:to_sym)
                    when :horizontal
                      self.layout = :horizontal
                      'form form-horizontal'
                    when :inline
                      self.layout = :inline
                      'form form-inline'
                    else
                      self.layout = :basic
                      options[:layout] = :basic
                      'form'
                  end

    html_options[:class] = squeeze_n_strip("#{form_layout} #{html_options[:class]}")
    options[:html]       = html_options

    super
  end

  # TODO: file_field, check_box, radio_button, color_field, date_field, time_field, datetime_field,
  #       datetime_local_field, month_field, week_field, range_field

  @@field_helpers.each do |helper|
    define_method helper do |object_name, method, options={}|
      label_class, field_wrapper = case self.layout
                                     when :inline
                                       'sr-only'
                                     when :horizontal
                                       ['col-sm-3 control-label', true]
                                     else
                                   end

      options[:class] = squeeze_n_strip("form-control #{options[:class]}")

      content_tag :div, class: 'form-group' do
        if field_wrapper
          (label(object_name, method, options[:label], class: label_class) +
            (content_tag :div, class: 'col-sm-9' do
              super(object_name, method, options)
            end)).html_safe
        else
          (label(object_name, method, options[:label], class: label_class) + super(object_name, method, options)).html_safe
        end
      end
    end
  end

  class ActionView::Helpers::FormBuilder
    include BootstrapFormHelper

    attr_accessor :output_buffer

    def submit(value=nil, options={})
      value, options = nil, value if value.is_a?(Hash)
      value ||= submit_default_value

      options[:class] = "btn btn-primary #{options[:class]}"

      if BootstrapFormHelper.layout == :horizontal
        content_tag :div, class: 'form-group' do
          content_tag :div, class: 'col-sm-offset-3 col-sm-9' do
            @template.submit_tag(value, options)
          end
        end
      else
        @template.submit_tag(value, options)
      end
    end
  end

end

