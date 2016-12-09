"use strict";

// This will be a persistent reference to the canvas
// we will use for rendering.
var canvas;

// Create the audio context and an analyser with
// 64 entries.
var audioCtx = new (window.AudioContext || window.webkitAudioContext)();

var analyser = audioCtx.createAnalyser();
analyser.fftSize = 64;

// Create a buffer to hold the frequency data.
var bufferLength = analyser.frequencyBinCount;
var dataArray = new Uint8Array(bufferLength);

// Connect the analyser to the microphone input
// (may require user approval)
navigator.webkitGetUserMedia({ audio: true },
  function(stream) {
    var source = audioCtx.createMediaStreamSource(stream);
    source.connect(analyser);
  }, function(error) {
    console.error(error);
  });

// Create the canvas if it has not already been created.
exports.createCanvas = function() {
  if (!canvas) {
    canvas = document.createElement("canvas");
    document.body.appendChild(canvas);
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
  }
  return canvas;
};

// This is a persistent reference to the most recent
// timer object used to render a scene.
var lastInterval;

// Animate a scene by replacing lastInterval with
// a new timer which will render the new scene.
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
