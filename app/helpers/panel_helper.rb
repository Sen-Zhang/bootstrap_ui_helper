module PanelHelper
  include ActionView::Helpers

  class PanelCreator
    include FormatHelper
    include ActionView::Helpers

    attr_accessor :content
    attr_accessor :options
    attr_accessor :block
    attr_accessor :output_buffer

    def initialize(content=nil, options, block)
      @content = content
      @options = options
      @block   = block
    end

    def render
      heading = options.delete(:heading)
      title   = options.delete(:title)
      footer  = options.delete(:footer)
      tag     = options.delete(:tag).try(:to_sym).presence || :div
      type    = get_panel_type(options.delete(:type))

      prepend_class(options, 'panel', type)

      content_tag tag, options do
        (panel_header(heading, title) + panel_body(content, block) +
          panel_footer(footer)).html_safe
      end
    end

    private
    def panel_header(heading, title)
      return '' if heading.blank? && title.blank?

      if title.present?
        "<div class='panel-heading'><h3 class='panel-title'>#{title}</h3></div>"
      else
        "<div class='panel-heading'>#{heading}</div>"
      end
    end

    def panel_body(content, block)
      content_tag :div, class: 'panel-body' do
        content.presence || block
      end
    end

    def panel_footer(footer)
      footer.present? ? "<div class='panel-footer'>#{footer}</div>" : ''
    end

    def get_panel_type(type)
      case type.try(:to_sym)
        when :primary
          'panel-primary'
        when :info
          'panel-info'
        when :success
          'panel-success'
        when :warning
          'panel-warning'
        when :danger
          'panel-danger'
        else
          'panel-default'
      end
    end
  end

  def panel(content_or_options=nil, options={}, &block)
    content_or_options.is_a?(Hash) ? options = content_or_options : content = content_or_options

    PanelCreator.new(content, options, capture(&block)).render
  end
end
