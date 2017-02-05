$(function() {
  // https://datatables.net/reference/option/
  var table = $('.songs-table').DataTable({
    dom: 'lrtip', // no f option removes the default table filter
    serverSide: true,
    responsive: true,
    pageLength: 10,
    lengthChange: false,
    ordering: false,
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
    showSongPreview($(this).data('song-id'));
    $('.songs-table .selected').removeClass('selected');
    $(this).addClass('selected');
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

  var hideDrawer = function() {
    $('.preview-drawer').hide();
    $('.songs-table tr.selected').removeClass('selected');
  }

  var showSongPreview = function(songId) {
    var url = '/songs/' + songId + '.json';

    $.getJSON(url, function(song) {
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
        id: song.id,
        name: name,
        artist: artist,
        chordSheet: chordSheet,
        key: song.key,
        tempo: song.tempo,
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

    var drawer = $('.preview-drawer');
    drawer.find('.name')
      .html(song.name);
    drawer.find('.page-link')
      .attr('href', '/songs/' + song.id);
    drawer.find('.song-sheet').html(song.chordSheet);

    if (song.artist) drawer.find('.artist').html(song.artist);
    if (song.tempo) drawer.find('.tempo').append(song.tempo);
    if (song.key) drawer.find('.key').text(song.key);
  }

  var wipeDrawer = function() {
    $('.preview-drawer').find('.name, .artist, .tempo, .key, .song-sheet')
      .html('');
  }
});
