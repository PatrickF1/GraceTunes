$(function () {
  $('#transpose_to').on('change', function (e) {
    viewWithChords();
  });

  $('#to_chords').click(function (e) {
    viewWithChords();
  });

  $('#chords_toggle').click(function (e) {
    let enableChords = $(e.target).prop('checked');
    if(enableChords) {
      viewWithChords();
      return;
    }

    viewNoChords();
  })

  $('#to_numbers').click(function (e) {
    viewNumbers();
  });

  let viewNumbers = function () {
    updateChordSheet({ numbers: true }, $(this).data("song-url"));
    updatePrintLink("numbers");
    hideToNumbersButton();
    showToChordsButton();
  }

  let viewNoChords = function () {
    updatePrintLink("none");
    updateChordSheet({ disable_chords: true }, $(this).data("song-url"));
  }

  let viewWithChords = function () {
    let newKey = $('#transpose_to option:selected').val();
    let transposeUrl = $("#transpose_to").data('song-url');
    updateChordSheet({ new_key : newKey }, transposeUrl);
    updatePrintLink(newKey);
    showToNumbersButton();
    hideToChordsButton();
  }

  let updateChordSheet = function (options, songUrl) {
    $.getJSON(songUrl, options, function (song) {
      $('.chord-sheet').html(song.chord_sheet);
    });
  }

  let updatePrintLink = function (newKey) {
    let param = {}
    let $button = $('#print-btn');
    if (newKey === "none") {
      param = { disable_chords: true }
    } else if (newKey === "numbers") {
      param = { numbers: true }
    } else {
      param = { new_key: newKey }
    }
    // using $.param to generate query param in order to escape sharps
    let printUrl = $button.data('print-url') + "?" + $.param(param)
    $button.attr('href', printUrl);
  }

  let showToNumbersButton = function () {
    $('.to-numbers-container').show();
  }

  let showToChordsButton = function () {
    $('.to-chords-container').show();
  }

  let hideToNumbersButton = function () {
    $('.to-numbers-container').hide();
  }

  let hideToChordsButton = function () {
    $('.to-chords-container').hide();
  }
});