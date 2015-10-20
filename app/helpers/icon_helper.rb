module IconHelper

  class IconCreator
    include ValidIcons
    include FormatHelper
    include ActionView::Helpers

    attr_accessor :type
    attr_accessor :options

    def initialize(type, options)
      @type    = type.to_s.gsub('_', '-')
      @options = options
    end

    def render
      render_fa_class(options)

      content_tag :i, nil, options
    end

    private
    def render_fa_class(options)
      type = "fa-#{@type}"
      raise 'Invalid Icon Type!' if ValidIcons::VALID_ICONS.exclude?(type)

      size        = get_icon_size(options.delete(:size))
      fw          = options.delete(:fw).presence ? 'fa-fw' : nil
      li          = options.delete(:li).presence ? 'fa-li' : nil
      inverse     = options.delete(:inverse).presence ? 'fa-inverse' : nil
      border      = options.delete(:border).presence ? 'fa-border' : nil
      pull        = get_icon_position(options.delete(:pull))
      animate     = get_icon_animation(options.delete(:animate))
      orientation = get_icon_orientation(options.delete(:orientation))

      # TODO add fa-stack support
      # stack = options.delete(:stack).presence

      prepend_class(options, 'fa', type, size, fw, li, inverse, border, pull,
                    animate, orientation)
    end

    def get_icon_size(size)
      case size.try(:to_sym)
      when :lg
        'fa-lg'
      when :'2x'
        'fa-2x'
      when :'3x'
        'fa-3x'
      when :'4x'
        'fa-4x'
      when :'5x'
        'fa-5x'
      else
      end
    end

    def get_icon_position(position)
      case position.try(:to_sym)
      when :right
        'fa-pull-right'
      when :left
        'fa-pull-left'
      else
      end
    end

    def get_icon_animation(animation)
      case animation.try(:to_sym)
      when :spin
        'fa-spin'
      when :pulse
        'fa-pulse'
      else
      end
    end

    def get_icon_orientation(orientation)
      case orientation.try(:to_sym)
      when :'90'
        'fa-rotate-90'
      when :'180'
        'fa-rotate-180'
      when :'270'
        'fa-rotate-270'
      when :horizontal
        'fa-flip-horizontal'
      when :vertical
        'fa-flip-vertical'
      else
      end
    end
  end

  def icon(type=nil, options={})
    raise 'Please provide an icon type!' if type.blank?

    IconCreator.new(type, options).render
  end

  def icon_list(options={}, &block)
    prepend_class(options, 'fa-ul')

    content_tag :ul, options, &block
  end

  def icon_list_item(content_or_options, options={}, &block)
    content, options = parse_content_or_options(content_or_options, options)
    icon_options     = options.delete(:icon_html)
    icon             = icon(icon_options.delete(:type), icon_options)

    content_tag :li, options do
      (icon + (content.presence || capture(&block))).html_safe
    end
  end
end
