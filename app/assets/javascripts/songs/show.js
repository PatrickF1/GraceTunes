$(function() {

  $('#transpose_to').on('change', function(e) {
    var newKey = $('#transpose_to option:selected').val();
    var tranposeUrl = $("#transpose_to").data('song-url');
    transposeChordSheet(newKey, tranposeUrl);
    updatePrintLink(newKey);
  });

  $('#to_numbers').click(function(e){
    formatAsNumbers($(this).data("song-url"));
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
    showTransposeControls();
    showToNumbersButton();
    hideToChordsButton();
  })

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

  var updatePrintLink = function(newKey){
    var param = {}
    if(newKey == "numbers"){
      var buttonHtml = $('#print-btn').html();
      $('#print-btn').html(buttonHtml.replace("in current key", "with numbers"));
      param = { numbers: true }
    }else{
      var buttonHtml = $('#print-btn').html();
      $('#print-btn').html(buttonHtml.replace("with numbers", "in current key"));
      param = { new_key: newKey }
    }
    // using $.param to generate query param in order to escape sharps
    var printUrl = $('#print-btn').data('print-url') + "?" + $.param(param)
    $('#print-btn').attr('href', printUrl);
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