module DropdownHelper

  class DropdownListItem
    include ActionView::Helpers

    attr_accessor :options

    def initialize(args={})
      @options = args
    end

    def construct
      klass   = options.delete(:class).try(:to_s)
      content = nil

      case options[:type].try(:to_sym)
        when :link
          content = link_to options[:text], options[:link]
        when :header
          options.merge!({class: "dropdown-header #{klass}".squeeze(' ').strip})
          content = options[:text]
        when :divider
          options.merge!({class: "divider #{klass}".squeeze(' ').strip, role: 'separator'})
        else
      end

      content_tag :li, content, options
    end
  end

  def dropdown(content=nil, list=[], options={})
    return if content.blank? || list.empty?

    btn_id, klass, align, direction, size, type = process_options(options)

    btn_options  = button_options(content, size, type, btn_id)
    list_options = list_options(btn_id, align)

    options.merge!({class: "btn-group #{direction == :up ? 'dropup' : 'dropdown'} #{klass}".squeeze(' ').strip})

    content_tag :div, options do
      (dropdown_button(btn_options) + dropdown_list(list, list_options)).html_safe
    end
  end

  private
  def process_options(options)
    btn_id    = options.delete(:id) || "dropdown-#{rand(0...999)}"
    klass     = options.delete(:class)
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

    [btn_id, klass, align, direction, size, type]
  end

  def button_options(content, size, type, id)
    {
      content: content,
      class: "dropdown-toggle #{size} #{type}",
      id: id,
      data: {toggle: 'dropdown'},
      aria: {haspopup: true, expended: false}
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

    button_tag options do
      (content + " <span class='caret'></span>").html_safe
    end
  end

  def dropdown_list(list_items, options={})
    options[:class].prepend('dropdown-menu ')

    content_tag :ul, options do
      list_items.map { |item| DropdownListItem.new(item).construct }.join('').html_safe
    end
  end

end
