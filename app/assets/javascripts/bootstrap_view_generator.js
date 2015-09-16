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
   * Wrap each child of nav with +li+ tag and put class +active+ to indicated active element
   *
   */
  $.fn.nav = function () {
    var $this = $(this),
      activeChildLocator = $this.data('active-el-locator'),
      children = $this.children();

    if (activeChildLocator % 1 == 0) {
      $(children[activeChildLocator]).attr('active', true);
    } else {
      $this.children(activeChildLocator).attr('active', true);
    }

    $this.children().remove();

    children.each(function () {
      var $child = $(this),
        wrapper = createElement('li', {role: "presentation"});

      if ($child.attr('active') === 'true') {
        $child.removeAttr('active');
        wrapper.addClass('active');
      }

      $this.append(wrapper.append($child));
    });
  };

  $(function () {

    /* Initialize Nav */
    $('[data-bvg="nav"]').nav();

  })
})(jQuery);
