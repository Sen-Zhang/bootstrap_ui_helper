module PanelRowHelper

  def panel_row(options={}, &block)
    column_class = options.delete(:column_class) || ''

    options.deep_merge!(data: {bui: 'panel_row', column_class: column_class})
    prepend_class(options, 'row')

    content_tag :div, options, &block
  end
end
