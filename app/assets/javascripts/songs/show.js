$(function() {
  $('#transpose_to').on('change', function(e) {
    var newKey = $('#transpose_to option:selected').val();
    transposeChordSheet(newKey);

    var printUrl = getSongBaseUrl() + "/print?new_key=" + newKey;
    $('#print-btn').attr('href', printUrl);
  });

  var transposeChordSheet = function(newKey) {
    var url = getSongBaseUrl() + '.json';

    $.getJSON(url, { "new_key": newKey }, function(data) {
      var chordSheet = data.song.chord_sheet;
      $('.chord-sheet').html(chordSheet);
    });
  }

  var getSongBaseUrl = function() {
    var songId = window.location.pathname.split('/')[2];
    return `/songs/${songId}`;
  };
})