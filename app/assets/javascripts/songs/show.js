$(function() {

  $('#transpose_to').on('change', function(e) {
    viewWithChords();
  });

  $('#to_chords').click(function(e) {
    viewWithChords();
  });

  $('#to_numbers').click(function(e) {
    updateChordSheet({ numbers: true }, $(this).data("song-url"));
    updatePrintLink("numbers");
    hideToNumbersButton();
    showToChordsButton();
  });

  var viewWithChords = function() {
    var newKey = $('#transpose_to option:selected').val();
    var tranposeUrl = $("#transpose_to").data('song-url');
    updateChordSheet({ new_key : newKey }, tranposeUrl);
    updatePrintLink(newKey);
    showToNumbersButton();
    hideToChordsButton();
  }

  var updateChordSheet = function(options, songUrl) {
    $.getJSON(songUrl, options, function(song) {
      $('.chord-sheet').html(song.chord_sheet);
    });
  }

  var updatePrintLink = function(newKey) {
    var param = {}
    if (newKey == "numbers") {
      var buttonHtml = $('#print-btn').html();
      $('#print-btn').html(buttonHtml.replace("in current key", "with numbers"));
      param = { numbers: true }
    } else {
      var buttonHtml = $('#print-btn').html();
      $('#print-btn').html(buttonHtml.replace("with numbers", "in current key"));
      param = { new_key: newKey }
    }
    // using $.param to generate query param in order to escape sharps
    var printUrl = $('#print-btn').data('print-url') + "?" + $.param(param)
    $('#print-btn').attr('href', printUrl);
  }

  var showToNumbersButton = function() {
    $('.to-numbers-container').show();
  }

  var showToChordsButton = function() {
    $('.to-chords-container').show();
  }

  var hideToNumbersButton = function() {
    $('.to-numbers-container').hide();
  }

  var hideToChordsButton = function() {
    $('.to-chords-container').hide();
  }

});