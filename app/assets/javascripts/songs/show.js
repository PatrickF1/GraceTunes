$(function() {
  $('#transpose_to').on('change', function(e) {
    var newKey = $('#transpose_to option:selected').val();
    transposeChordSheet(newKey)
  });

  var transposeChordSheet = function(newKey) {
    var songId = window.location.pathname.split('/')[2];
    var url = `/songs/${songId}.json`;

    $.getJSON(url, { "new_key": newKey }, function(data) {
      var chordSheet = data.song.chord_sheet;
      console.log(chordSheet)
      $('.chord-sheet').html(chordSheet);
    });
  }

})