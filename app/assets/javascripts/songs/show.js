$(function() {
  $('#transpose_to').on('change', function(e) {
    var newKey = $('#transpose_to option:selected').val();
    var tranposeUrl = $("#transpose_to").data('song-url');
    transposeChordSheet(newKey, tranposeUrl);
    updatePrintLink(newKey);
  });

  $('#to_numbers').click(function(e){
    transposeChordSheet("numbers", $(this).data("song-url"));
  });

  var transposeChordSheet = function(newKey, songUrl) {
    $.getJSON(songUrl, { new_key: newKey }, function(song) {
      $('.chord-sheet').html(song.chord_sheet);
    });
  }

  var updatePrintLink = function(newKey){
    // using $.param to generate query param in order to escape sharps
    var printUrl = $('#print-btn').data('print-url') + "?" +
      $.param({ new_key: newKey })
    $('#print-btn').attr('href', printUrl);
  }
});