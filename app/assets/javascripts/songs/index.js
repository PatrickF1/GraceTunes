$(function() {
  var table = $('.songs-table').DataTable({
    serverSide: true,
    responsive: true,
    lengthChange: false,
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
    var url = '/songs/' + $(this).data('song-id') + '.json';
    $('.songs-table .selected').removeClass('selected');
    $(this).addClass('selected');

    $.get(url, function (data) {
      var song = data.song;
      var songSheet = song.song_sheet;
      var keywords = $('#songs-search-field').val();

      if (keywords !== '') {
        songSheet = highlightedSongSheet(keywords, songSheet);
      }

      populateDrawer({
        name: song.name,
        songSheet: songSheet,
        key: song.key || 'n/a',
        tempo: song.tempo || 'n/a'
      });

      $('.preview-drawer').show();
    });
  });

  $('.preview-drawer .close-button').click(function() {
    $('.preview-drawer').hide();
    $('.songs-table tr.selected').removeClass('selected');
  });

  var uniqueMatches = function(matches) {
    var uniqueWords = {};
    $.each(matches, function(i, match) {
      uniqueWords[match] = null;
    });

    return Object.keys(uniqueWords);
  };

  // highlight the keywords they searched for in the song sheet
  var highlightedSongSheet = function(keywords, songSheet) {
    var highlightedSheet = songSheet;

    $.each(keywords.split(' '), function(i, keyword) {
      var matches = songSheet.match(new RegExp(keyword, 'ig'));
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
    var drawer = $('.preview-drawer');
    drawer.find('.name').text(song.name);
    drawer.find('.song-sheet').html(song.songSheet);
    drawer.find('.tempo').text('Tempo: ' + song.tempo);
    drawer.find('.key').text('Key: ' + song.key);
  }
});
