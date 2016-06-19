"use strict";

var lastInterval;

exports.animateImpl = function(f) {
  return function() {
    lastInterval && window.clearInterval(lastInterval);
    lastInterval = window.setInterval(function() {
      f(new Date().getTime())();
    }, 1000 / 60);
  };
};
