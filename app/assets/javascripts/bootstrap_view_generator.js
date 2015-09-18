(function ($) {
  'use strict';

  /*
   * create a jquery DOM element based on tag name and options
   *
   */
  var createElement = function (tag, options) {
    var $el = $(document.createElement(tag));

    return $el.attr(options);
  };

  /*
   * Nav
   * Wrap each child nav with +li+ tag and put class +active+ to indicated active element
   *
   */
  $.fn.nav = function () {
    var $this              = $(this),
        activeChildLocator = $this.data('active-el-locator'),
        children           = $this.children();

    if (activeChildLocator % 1 == 0) {
      $(children[activeChildLocator]).attr('active', true);
    } else {
      $this.children(activeChildLocator).attr('active', true);
    }

    $this.children().remove();

    children.each(function () {
      var $child  = $(this),
          wrapper = createElement('li', {role: "presentation"});

      if ($child.attr('active') === 'true') {
        $child.removeAttr('active');
        wrapper.addClass('active');
      }

      $this.append(wrapper.append($child));
    });
  };

  /*
   * Panel Row
   * Wrap each child panel with indicated column-class
   *
   */
  $.fn.panelRow = function () {
    var $this       = $(this),
        columnClass = $this.data('column-class'),
        children    = $this.children();

    $this.children().remove();

    children.each(function () {
      var $child  = $(this),
          wrapper = createElement('div', {});

      $this.append(wrapper.addClass(columnClass).append($child));
    });
  };

  $(function () {

    /* Initialize Nav */
    $('[data-bvg="nav"]').nav();

    /* Initialize Panel Row */
    $('[data-bvg="panel_row"]').panelRow();

  })
})(jQuery);
