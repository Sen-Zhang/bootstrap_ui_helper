module IconHelper

  class IconCreator
    include ValidIcons
    include FormatHelper
    include ActionView::Helpers

    attr_accessor :type
    attr_accessor :options

    def initialize(type, options)
      @type    = type
      @options = options
    end

    def build
      icon_options = {
        type:        type,
        size:        options.delete(:size).presence || :normal,
        fw:          options.delete(:fixed_with).presence,
        li:          options.delete(:list_icon).presence,
        inverse:     options.delete(:inverse).presence,
        border:      options.delete(:border).presence,
        pull:        options.delete(:pull).presence,
        animate:     options.delete(:animate).presence,
        orientation: options.delete(:orientation).presence

        # TODO add fa-stack support
        # stack = options.delete(:stack).presence
      }

      prepend_class(options, 'fa', build_fa_class(icon_options))

      content_tag :i, nil, options
    end

    private
    def build_fa_class(options)
      type = "fa-#{options[:type]}"
      raise 'Invalid Icon Type!' if ValidIcons::VALID_ICONS.exclude?(type)

      size        = get_icon_size(options.delete(:size))
      fw          = options[:fw].presence ? 'fa-fw' : nil
      li          = options[:li].presence ? 'fa-li' : nil
      inverse     = options[:inverse].presence ? 'fa-inverse' : nil
      border      = options[:border].presence ? 'fa-border' : nil
      pull        = get_icon_position(options[:pull])
      animate     = get_icon_animation(options[:animate])
      orientation = get_icon_orientation(options[:orientation])

      "#{type} #{size} #{fw} #{li} #{inverse} #{border} #{pull} #{animate} #{orientation}"
    end
  end

  def icon(type=nil, options={})
    raise 'Please provide an icon type!' if type.blank?

    IconCreator.new(type, options).build
  end

  private

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
