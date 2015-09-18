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

    def build
      heading = options.delete(:heading)
      title   = options.delete(:title)
      footer  = options.delete(:footer)
      tag     = options.delete(:tag).try(:to_sym).presence || :div
      klass   = options.delete(:class)
      type    = case options.delete(:type)
                  when 'primary', :primary
                    'panel-primary'
                  when 'info', :info
                    'panel-info'
                  when 'success', :success
                    'panel-success'
                  when 'warning', :warning
                    'panel-warning'
                  when 'danger', :danger
                    'panel-danger'
                  else
                    'panel-default'
                end

      options.merge!({class: squeeze_n_strip("panel #{type} #{klass}")})

      content_tag tag, options do
        (panel_header(heading, title) + panel_body(content, block) + panel_footer(footer)).html_safe
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
  end

  def panel(content_or_options=nil, options={}, &block)
    content_or_options.is_a?(Hash) ? options = content_or_options : content = content_or_options

    PanelCreator.new(content, options, capture(&block)).build
  end

end
