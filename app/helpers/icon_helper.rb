module IconHelper
  include ValidIcons

  def icon(type=nil, options={})
    raise 'Please provide an icon type!' if type.blank?

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

    klass = options.delete(:class)

    content_tag :i, nil, class: squeeze_n_strip("fa #{build_fa_class(icon_options)} #{klass}")
  end

  private
  def build_fa_class(options)
    type = "fa-#{options[:type]}"
    raise 'Invalid Icon Type!' if valid_icons.exclude?(type)

    size        = case options[:size]
                    when 'lg', :lg
                      'fa-lg'
                    when '2x', :'2x'
                      'fa-2x'
                    when '3x', :'3x'
                      'fa-3x'
                    when '4x', :'4x'
                      'fa-4x'
                    when '5x', :'5x'
                      'fa-5x'
                    else
                  end
    fw          = options[:fw].presence ? 'fa-fw' : nil
    li          = options[:li].presence ? 'fa-li' : nil
    inverse     = options[:inverse].presence ? 'fa-inverse' : nil
    border      = options[:border].presence ? 'fa-border' : nil
    pull        = case options[:pull]
                    when 'right', :right
                      'fa-pull-right'
                    when 'left', :left
                      'fa-pull-left'
                    else
                  end
    animate     = case options[:animate]
                    when 'spin', :spin
                      'fa-spin'
                    when 'pulse', :pulse
                      'fa-pulse'
                    else
                  end
    orientation = case options[:orientation]
                    when '90', :'90'
                      'fa-rotate-90'
                    when '180', :'180'
                      'fa-rotate-180'
                    when '270', :'270'
                      'fa-rotate-270'
                    when 'horizontal', :horizontal
                      'fa-flip-horizontal'
                    when 'vertical', :vertical
                      'fa-flip-vertical'
                    else
                  end

    "#{type} #{size} #{fw} #{li} #{inverse} #{border} #{pull} #{animate} #{orientation}"
  end
end
