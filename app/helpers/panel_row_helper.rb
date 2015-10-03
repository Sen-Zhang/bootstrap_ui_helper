module PanelRowHelper

  def panel_row(options={}, &block)
    column_class = options.delete(:column_class) || ''
    data         = (options[:data] || {}).merge(bvg: 'panel_row',
                                                column_class: column_class)
    options[:data] = data
    prepend_class(options, 'row')

    content_tag :div, options, &block
  end
end
