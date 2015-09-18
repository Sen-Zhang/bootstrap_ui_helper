module PanelRowHelper

  def panel_row(options={}, &block)
    data  = (options.delete(:data) || {}).merge({bvg: 'panel_row'})
    klass = squeeze_n_strip("row #{options.delete(:class)}")

    data.merge!(column_class: (options.delete(:column_class) || ''))

    content_tag :div, options.merge({class: klass, data: data}) do
      yield if block_given?
    end
  end

end
