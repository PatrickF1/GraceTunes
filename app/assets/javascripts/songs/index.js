$(function() {
  var table = $('.songs-table').DataTable({
    serverSide: true,
    responsive: true,
    lengthChange: false,
    ordering: false,
    dom: '',
    columns: [
      { data: 'name' },
      { data: 'artist' },
      { data: 'tempo' },
      { data: 'key' },
    ],
    createdRow: function(row, data, index) {
      $(row).data('song-id', data.id);
    },
    ajax: {
      sAjaxSource: '<%= songs_path(format: :json) %>',
      data: function(d) {
        d.tempo = $('#tempo').val();
        d.key = $('#key').val();

        return d;
      }
    }
  });

  $('#songs-search-field').keyup(function() {
    table.search(this.value).draw();
  });

  $('.filter-selection').change(function() {
    table.ajax.reload();
  });

  $('.search-page').addClass('active');

  // show preview drawer on table row click
  $('.songs-table').on('click', 'tbody tr', function() {
    showSongChords($(this).data('song-id'));
    $('.songs-table .selected').removeClass('selected');
    $(this).addClass('selected');
  });

  $('#transpose_to').on('change', function(e){
    var newKey = $('#transpose_to option:selected').val();
    showSongChords($('.songs-table .selected').data('song-id'), { "new_key": newKey });
  });

  $('#numbers').click(function() {
    showSongChords($('.songs-table .selected').data('song-id'), { "to_numbers": true });
  });

  $('.preview-drawer .close-button').click(function() {
    hideDrawer();
  });

  // hide drawer when escape key is pressed
  $('body').keyup(function(e) {
    var escKey = 27;
    if (e.keyCode == escKey) hideDrawer();
  });

  // hide drawer if anything outside of the table & drawer are clicked
  $('body').click(function(e) {
    var drawer = $('.preview-drawer');
    var target = $(e.target);

    if (!target.parents('.songs-table').length &&
      !target.parents('.preview-drawer').length && !target.is(drawer)) {
      hideDrawer();
    }
  });

  var showSongChords = function(songId, params) {
    var url = '/songs/' + songId + '.json';

    $.getJSON(url, params, function(data) {
      var song = data.song;
      var chordSheet = song.chord_sheet;
      var artist = song.artist;
      var name = song.name;
      var keywords = $('#songs-search-field').val();

      if (keywords !== '') {
        chordSheet = highlightedKeywords(keywords, chordSheet);

        if (artist) {
          artist = highlightedKeywords(keywords, artist);
        }

        name = highlightedKeywords(keywords, name);
      }

      populateDrawer({
        name: name,
        artist: artist,
        chordSheet: chordSheet,
        key: song.key,
        originalKey: song.original_key,
        printPath: song.print_path,
        tempo: song.tempo,
        editPath: song.edit_path
      });

      $('.preview-drawer').show();
    });
  }

  var uniqueMatches = function(matches) {
    var uniqueWords = {};
    $.each(matches, function(i, match) {
      uniqueWords[match] = null;
    });

    return Object.keys(uniqueWords);
  };

  // highlight the keywords they searched for in some text
  var highlightedKeywords = function(keywords, text) {
    var highlightedSheet = text;

    $.each(keywords.split(' '), function(i, keyword) {
      var matches = text.match(new RegExp(keyword, 'ig'));
      if (!matches) return;
      var matches = uniqueMatches(matches);

      $.each(matches, function(i, match) {
        var highlightedMatch = '<span class="highlight">' + match + '</span>';
        highlightedSheet = highlightedSheet.replace(new RegExp(match, 'g'), highlightedMatch);
      });
    });

    return highlightedSheet;
  }

  var populateDrawer = function(song) {
    wipeDrawer();
    wipeTransposeSelect();

    var drawer = $('.preview-drawer');
    drawer.find('.name').html(song.name);
    drawer.find('.song-sheet').html(song.chordSheet);
    drawer.find('.actions .edit').attr('href', song.editPath);
    drawer.find('.actions .print').attr('href', song.printPath);

    if (song.artist) drawer.find('.artist').html('by ' + song.artist);
    if (song.tempo) drawer.find('.tempo').text('Tempo: ' + song.tempo);
    if (song.key) drawer.find('.key').text('Key: ' + song.key);

    var originalKeyIndex = $('#transpose_to option').index($('#transpose_to option[value="'+song.originalKey+'"]'));
    var currentKeyIndex = $('#transpose_to option').index($('#transpose_to option[value="'+song.key+'"]'));
    $('#transpose_to option').each(function(index, el){
      if(currentKeyIndex == index){
        $('#transpose_to').prop("selectedIndex", index);
      }
      var offset = index - originalKeyIndex;
      if(offset == 0){
        $(el).html($(el).html() + " (original)");
      } else {
        $(el).html($(el).html() + " (" + offset + ")");
      }
    });
  }

  var hideDrawer = function() {
    $('.preview-drawer').hide();
    wipeDrawer();
    $('.songs-table tr.selected').removeClass('selected');
  }

  var wipeDrawer = function() {
    $('.preview-drawer').find('.name, .artist, .tempo, .key, .song-sheet')
      .html('');
  }

  var wipeTransposeSelect = function(){
    $('#transpose_to option').each(function(index, el){
      $(el).html($(el).html().split(" ")[0]);
    });
    $('#transpose_to').removeProp("selectedIndex");
  }
});
