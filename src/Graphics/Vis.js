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

// See https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia
//
// BEGIN SHIM
// Older browsers might not implement mediaDevices at all, so we set an empty object first
if (navigator.mediaDevices === undefined) {
  navigator.mediaDevices = {};
}

// Some browsers partially implement mediaDevices. We can't just assign an object
// with getUserMedia as it would overwrite existing properties.
// Here, we will just add the getUserMedia property if it's missing.
if (navigator.mediaDevices.getUserMedia === undefined) {
  navigator.mediaDevices.getUserMedia = function(constraints) {

    // First get ahold of the legacy getUserMedia, if present
    var getUserMedia = navigator.webkitGetUserMedia || navigator.mozGetUserMedia;

    // Some browsers just don't implement it - return a rejected promise with an error
    // to keep a consistent interface
    if (!getUserMedia) {
      return Promise.reject(new Error('getUserMedia is not implemented in this browser'));
    }

    // Otherwise, wrap the call to the old navigator.getUserMedia with a Promise
    return new Promise(function(resolve, reject) {
      getUserMedia.call(navigator, constraints, resolve, reject);
    });
  }
}
// END SHIM

// Connect the analyser to the microphone input
// (may require user approval)
navigator.mediaDevices.getUserMedia({ audio: true })
  .then(function(stream) {
    var source = audioCtx.createMediaStreamSource(stream);
    source.connect(analyser);
  })
  .catch(function(error) {
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
