"use strict";

var canvas;

exports.createCanvas = function() {
  if (!canvas) {
    canvas = document.createElement("canvas");
    canvas.width = window.width;
    canvas.height = window.height;
    canvas.style.width  = window.width + 'px';
    canvas.style.height = window.height + 'px';
    document.body.appendChild(canvas);
  }
  return canvas;
};

var lastInterval;

exports.animateImpl = function(f) {
  return function() {
    lastInterval && window.clearInterval(lastInterval);
    lastInterval = window.setInterval(function() {
      f(new Date().getTime())();
    }, 1000 / 60);
  };
};
