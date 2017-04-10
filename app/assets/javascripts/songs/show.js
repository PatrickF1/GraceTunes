$(function() {

  $('#transpose_to').on('click', function(e) {
    var newKey = $('#transpose_to option:selected').val();
    var tranposeUrl = $("#transpose_to").data('song-url');
    transposeChordSheet(newKey, tranposeUrl);
    updatePrintLink(newKey);
  });

  $('#to_numbers').click(function(e) {
    formatAsNumbers($(this).data("song-url"));
    updatePrintLink("numbers");
  });

  var transposeChordSheet = function(newKey, songUrl) {
    $.getJSON(songUrl, { new_key: newKey }, function(song) {
      $('.chord-sheet').html(song.chord_sheet);
    });
  }

  var formatAsNumbers = function(songUrl) {
    $.getJSON(songUrl, { numbers: true }, function(song) {
      $('.chord-sheet').html(song.chord_sheet);
    });
  }

  var updatePrintLink = function(newKey) {
    var param = {}
    if(newKey == "numbers") {
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

});