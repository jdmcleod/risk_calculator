// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

// $(document).ready(function () {
//   $('.player-dropdown').on('change', function () {
//     var winner = $('#winner-dropdown');
//     var loser = $('#loser-dropdown');

//     var result = !(winner.val() && loser.val() && winner.val() != loser.val())
//     $('#process-roll').attr('disabled', result);
//   });

//   $('.rng-input').on('change', function () {
//     var result = !(Number.isInteger(parseInt($('#players').val())) && Number.isInteger(parseInt($('#rolls').val())));
//     $('#generate').attr('disabled', result);
//   });

//   $('.confirm').on('click', function () {
//     return confirm('Are you sure? This will overwrite any progress you have.');
//   });
// });




// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
