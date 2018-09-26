/* jquery.dltabs.js
 * jQuery tabs plugin for definition lists (dl)
 * Author: Jason Moon
 * Requires: jQuery
 */
(function($){
$.fn.dltabs = function(tabsOptions){
  options = $.extend(true, {
    activeClassName: '',
    inactiveClassName: '',
    activeTab: 0,
    displayEffect: {
      animation: 'none',
      speed: 'normal'
    }
  }, tabsOptions);
  // Determine the animation to use
  var effectType = options.displayEffect.animation.toLowerCase();
  var animation = {show: $.fn.show, hide: $.fn.hide, speed: options.displayEffect.speed};
  if (effectType == 'fade') {
    animation = $.extend(animation, {show: $.fn.fadeIn, hide: $.fn.fadeOut});
  }
  else if (effectType == 'slide') {
    animation = $.extend(animation, {show: $.fn.slideDown, hide: $.fn.slideUp});
  }
  else if (effectType != 'expand') {
    animation.speed = 0;
  }
  // Function to activate a tab
  var activateTab = function(activeIndex, animateFunction, speed){
    $('> dt', this).attr('class', options.inactiveClassName).eq(activeIndex).attr('class', options.activeClassName);
    animateFunction.call($('> dd', this).hide().eq(activeIndex), speed);
  };
  // Set up the dl
  return this.each(function(){
    if (this.tagName == 'DL') {
      var tabList = this;
      $('> dt', this).each(function(termIndex){
        // If this dt doesn't have a dd associated with it, create one
        if (!$('+ dd', this).length) {
          $(this).after('<dd/>');
        }
        // Assign the click
        $(this).css('float', 'left').click(function(){
          activateTab.call(tabList, termIndex, animation.show, animation.speed);
          return false;
        });
      }); // end dt-each
      // Clear the floating tabs, and move the dd's to the bottom, so the tabs (dt's) stick together
      $(this).append('<div style="clear:both"><!-- --></div>').find('> dd').appendTo(this);
      // Activate the first tab
      activateTab.call(this, options.activeTab, $.fn.show, 0);
    }
    else if (window.console) {
      console.warn('The jQuery tabs plugin can only be run on a definition list (dl).');
    }
  });
};
})(jQuery);