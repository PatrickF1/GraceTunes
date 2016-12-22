$(function() {
  $('#song_chord_sheet').on({
    'input': handleInput,
    'scroll': handleScroll
  });

  function handleInput(){
    var text = $('#song_chord_sheet').val();
    var highlightedText = applyHighlights(text);
    $('.textarea-markup').html(highlightedText);
    $('.separator').height($('.textarea-markup').height());
  }

  function applyHighlights(text){
    // text = text.replace(/\n$/g, '\n\n')
    var lines = text.split('\n');
    for(var i = 0; i < lines.length; i++){
      var line = lines[i];
      var charsToLong = line.substring(45);

      if(line.length > 45){
        lines[i] = line.substring(0, 45) + '<mark>' + line.substring(45) + '</mark>';
        // lines[i] = line.replace(charsToLong, '<mark>'+charsToLong+'</mark>');
      }
    }

    return lines.join('\n').replace(/\n$/g, '\n\n'); // need to replace to fix alignment
  }

  function handleScroll(){
    var scrollTop = $('#song_chord_sheet').scrollTop();
    $('.backdrop').scrollTop(scrollTop);
  }

  handleInput();
});