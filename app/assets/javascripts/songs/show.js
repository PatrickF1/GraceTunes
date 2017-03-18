$(function() {

  $('#transpose_to').on('change', function(e) {
    var newKey = $('#transpose_to option:selected').val();
    var tranposeUrl = $("#transpose_to").data('song-url');
    transposeChordSheet(newKey, tranposeUrl);
    updatePrintLink(newKey);
  });

  $('#to_numbers').click(function(e){
    transposeChordSheet("numbers", $(this).data("song-url"));
    updatePrintLink("numbers");
    hideTransposeControls();
    hideToNumbersButton();
    showToChordsButton();
  });

  $('#to_chords').click(function(e){
    var newKey = $('#transpose_to option:selected').val();
    var tranposeUrl = $("#transpose_to").data('song-url');
    transposeChordSheet(newKey, tranposeUrl);
    updatePrintLink(newKey);
  })

  var transposeChordSheet = function(newKey, songUrl) {
    $.getJSON(songUrl, { new_key: newKey }, function(song) {
      $('.chord-sheet').html(song.chord_sheet);
    });
    showTransposeControls();
    showToNumbersButton();
    hideToChordsButton();
  }

  var updatePrintLink = function(newKey){
    // using $.param to generate query param in order to escape sharps
    var printUrl = $('#print-btn').data('print-url') + "?" +
      $.param({ new_key: newKey })
    $('#print-btn').attr('href', printUrl);

    if(newKey == "numbers"){
      var buttonHtml = $('#print-btn').html();
      $('#print-btn').html(buttonHtml.replace("in current key", "with numbers"));
    }else{
      var buttonHtml = $('#print-btn').html();
      $('#print-btn').html(buttonHtml.replace("with numbers", "in current key"));
    }
  }

  var showTransposeControls = function(){
    $('.transpose-container').show();
  }

  var showToNumbersButton = function(){
    $('.to-numbers-container').show();
  }

  var showToChordsButton = function(){
    $('.to-chords-container').show();
  }

  var hideTransposeControls = function(){
    $('.transpose-container').hide();
  }

  var hideToNumbersButton = function(){
    $('.to-numbers-container').hide();
  }

  var hideToChordsButton = function(){
    $('.to-chords-container').hide();
  }

});