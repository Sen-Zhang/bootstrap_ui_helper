module DropdownHelper

  # TODO: support split button dropdowns
  class DropdownListItem
    include FormatHelper
    include ActionView::Helpers

    attr_accessor :options

    def initialize(options={})
      @options = options
    end

    def construct
      klass   = options.delete(:class).try(:to_s)
      content = nil

      case options[:type].try(:to_sym)
        when :link
          content = link_to options[:text], options[:link], role: :menuitem, tabindex: -1
        when :header
          options.merge!({class: squeeze_n_strip("dropdown-header #{klass}")})
          content = options[:text]
        when :divider
          options.merge!({class: squeeze_n_strip("divider #{klass}"), role: 'separator'})
        else
      end

      content_tag :li, content, options
    end
  end

  class DropdownCreator
    include FormatHelper
    include ActionView::Helpers

    attr_accessor :content
    attr_accessor :list
    attr_accessor :options
    attr_accessor :output_buffer

    def initialize(content, list, options)
      @content = content
      @list    = list
      @options = options
    end

    def build
      navbar, btn_id, klass, align, direction, size, type = process_dropdown_options(options)

      btn_options  = button_options(content, size, type, btn_id, navbar)
      list_options = list_options(btn_id, align)

      tag = navbar ? :li : :div
      options.merge!({class: squeeze_n_strip("btn-group #{direction == :up ? 'dropup' : 'dropdown'} #{klass}")})

      content_tag tag, options do
        (dropdown_button(btn_options) + dropdown_list(list, list_options)).html_safe
      end
    end

    private
    def process_dropdown_options(options)
      navbar    = options.delete(:category).try(:to_sym) == :navbar
      btn_id    = options.delete(:id) || "dropdown-#{rand(0...999)}"
      klass     = options.delete(:class)
      active    = 'active' if options.delete(:active)
      align     = options.delete(:align).try(:to_sym)
      direction = options.delete(:direction).try(:to_sym)
      size      = case options.delete(:size).try(:to_sym)
                    when :xsmall
                      'btn-xs'
                    when :small
                      'btn-sm'
                    when :large
                      'btn-lg'
                    else
                  end
      type      = case options.delete(:type).try(:to_sym)
                    when :primary
                      'btn btn-primary'
                    when :info
                      'btn btn-info'
                    when :success
                      'btn btn-success'
                    when :warning
                      'btn btn-warning'
                    when :danger
                      'btn btn-danger'
                    else
                      'btn btn-default'
                  end

      [navbar, btn_id, "#{klass} #{active}", align, direction, size, type]
    end

    def button_options(content, size, type, id, navbar)
      klass = navbar ? 'dropdown-toggle' : "dropdown-toggle #{size} #{type}"

      {
        content: content,
        class: klass,
        id: id,
        data: {toggle: 'dropdown'},
        aria: {haspopup: true, expended: false},
        navbar: navbar
      }
    end

    def list_options(btn_id, align)
      {
        class: align == :right ? 'dropdown-menu-right' : 'dropdown-menu-left',
        role: 'menu',
        aria: {labelledby: btn_id}
      }
    end

    def dropdown_button(options={})
      content = options.delete(:content)
      navbar  = options.delete(:navbar)

      if navbar
        link_to '#', options do
          (content + " <span class='caret'></span>").html_safe
        end
      else
        button_tag options do
          (content + " <span class='caret'></span>").html_safe
        end
      end
    end

    def dropdown_list(list_items, options={})
      options[:class].prepend('dropdown-menu ')

      content_tag :ul, options do
        list_items.map { |item| DropdownListItem.new(item).construct }.join('').html_safe
      end
    end

  end

  def dropdown(content=nil, list=[], options={})
    return if content.blank? || list.empty?

    DropdownCreator.new(content, list, options).build
  end

  def navbar_dropdown(content=nil, list=[], options={})
    dropdown(content, list, options.merge({category: :navbar}))
  end

end
