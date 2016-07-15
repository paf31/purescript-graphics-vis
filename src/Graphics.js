"use strict";

var canvas;

var audioCtx = new (window.AudioContext || window.webkitAudioContext)();

var analyser = audioCtx.createAnalyser();
analyser.fftSize = 64;

var bufferLength = analyser.frequencyBinCount;
var dataArray = new Uint8Array(bufferLength);

navigator.webkitGetUserMedia({ audio: true },
  function(stream) {
    var source = audioCtx.createMediaStreamSource(stream);
    source.connect(analyser);
  }, function(error) {
    console.error(error);
  });

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
      // Read the data into the byte array
      analyser.getByteFrequencyData(dataArray);
      f(new Date().getTime())(dataArray.slice())();
    }, 1000 / 60);
  };
};
