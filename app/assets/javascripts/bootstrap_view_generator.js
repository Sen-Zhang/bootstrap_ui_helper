(function ($) {
  "use strict";

  /*
   * create a jquery DOM element based on tag name and options
   *
   */
  var createElement = function (tag, options) {
    var $el = $(document.createElement(tag));

    return options === undefined ? $el : $el.attr(options);
  };

  /*
   * Nav
   * Wrap each child nav with +li+ tag and put class +active+ to indicated
   * active element
   *
   */
  $.fn.nav = function () {
    var $this              = $(this),
        activeChildLocator = $this.data("active-el-locator"),
        children           = $this.children();

    if (activeChildLocator % 1 === 0) {
      $(children[activeChildLocator]).attr("active", true);
    } else {
      $this.children(activeChildLocator).attr("active", true);
    }

    $this.children().remove();

    children.each(function () {
      var $child  = $(this),
          wrapper = createElement("li", {role: "presentation"});

      if ($child.attr("active") === "true") {
        $child.removeAttr("active");
        wrapper.addClass("active");
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
        columnClass = $this.data("column-class"),
        children    = $this.children();

    $this.children().remove();

    children.each(function () {
      var $child  = $(this),
          wrapper = createElement("div");

      $this.append(wrapper.addClass(columnClass).append($child));
    });
  };

  /*
   * Button Group
   * make sure children button group has the same size of their parents"
   *
   */
  $.fn.buttonGroup = function () {
    var $this = $(this);

    $this.children(".btn-group").addClass($this.data("size"));
  };

  /*
   * Navbar Collapse
   *
   */
  $.fn.navBar = function () {
    var $this    = $(this),
      $burgerBtn = $this.find(".navbar-toggle"),
      $collapse  = $this.find(".navbar-collapse");

    if ($burgerBtn.length > 0 && $collapse.length > 0) {
      var collapseId = $collapse.attr("id");

      if ($collapse.attr("id") === undefined) {
        collapseId = Math.random().toString(36).substring(7);
        $collapse.attr("id", collapseId);
      }

      $burgerBtn.attr("data-target", "#" + collapseId);
    }
  };

  $(function () {

    /* Initialize Nav */
    $("[data-bvg='nav']").nav();

    /* Enable Navbar Collapse */
    $("[data-bvg='navbar']").navBar();

    /* Initialize Panel Row */
    $("[data-bvg='panel_row']").panelRow();

    /* Resize Button Group */
    $("[data-bvg='btn_group']").buttonGroup();

  });
})(jQuery);
