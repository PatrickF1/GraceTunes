$(function () {
  $('#transpose_to').on('change', function (e) {
    viewWithChords();
  });

  $('#to_chords').click(function (e) {
    viewWithChords();
  });

  $('#chords_toggle').click(function (e) {
    var enableChords = $(e.target).prop('checked');
    if(enableChords) {
      viewWithChords();
      return;
    }

    viewNoChords();
  })

  $('#to_numbers').click(function (e) {
    viewNumbers();
  });

  var viewNumbers = function () {
    updateChordSheet({ numbers: true }, $(this).data("song-url"));
    updatePrintLink("numbers");
    hideToNumbersButton();
    showToChordsButton();
  }

  var viewNoChords = function () {
    updatePrintLink("none");
    updateChordSheet({ disable_chords: true }, $(this).data("song-url"));
  }

  var viewWithChords = function () {
    var newKey = $('#transpose_to option:selected').val();
    var transposeUrl = $("#transpose_to").data('song-url');
    updateChordSheet({ new_key : newKey }, transposeUrl);
    updatePrintLink(newKey);
    showToNumbersButton();
    hideToChordsButton();
  }

  var updateChordSheet = function (options, songUrl) {
    $.getJSON(songUrl, options, function (song) {
      $('.chord-sheet').html(song.chord_sheet);
    });
  }

  var updatePrintLink = function (newKey) {
    var param = {}
    var $button = $('#print-btn');
    if (newKey === "none") {
      param = { disable_chords: true }
    } else if (newKey === "numbers") {
      param = { numbers: true }
    } else {
      param = { new_key: newKey }
    }
    // using $.param to generate query param in order to escape sharps
    var printUrl = $button.data('print-url') + "?" + $.param(param)
    $button.attr('href', printUrl);
  }

  var showToNumbersButton = function () {
    $('.to-numbers-container').show();
  }

  var showToChordsButton = function () {
    $('.to-chords-container').show();
  }

  var hideToNumbersButton = function () {
    $('.to-numbers-container').hide();
  }

  var hideToChordsButton = function () {
    $('.to-chords-container').hide();
  }
});