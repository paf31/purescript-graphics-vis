"use strict";

var canvas;

exports.createCanvas = function() {
  if (!canvas) {
    canvas = document.createElement("canvas");
    document.body.appendChild(canvas);
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
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
