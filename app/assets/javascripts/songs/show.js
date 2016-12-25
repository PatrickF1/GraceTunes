$(function() {
  $('#transpose_to').on('change', function(e) {
    var newKey = $('#transpose_to option:selected').val();
    transposeChordSheet(newKey);

  // using $.param to generate query param in order to escape sharps
    var printUrl = $('#print-btn').data('print-url') + "?" +
      $.param({ new_key: newKey })
    $('#print-btn').attr('href', printUrl);
  });

  var transposeChordSheet = function(newKey) {
    var tranposeUrl = $("#transpose_to").data('transpose-url')

    $.getJSON(tranposeUrl, { new_key: newKey }, function(song) {
      $('.chord-sheet').html(song.chord_sheet);
    });
  }
})