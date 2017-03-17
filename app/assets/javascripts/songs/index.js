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
      // render.text() patches an XSS vulnerability in dataTables
      // https://datatables.net/manual/security
      { data: 'name', render: $.fn.dataTable.render.text() },
      { data: 'artist', render: $.fn.dataTable.render.text() },
      { data: 'key' },
      { data: 'tempo' },
    ],
    createdRow: function(row, data, index) {
      // store song object to use later for showing song preview
      $(row).data('song', data);
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
    showSongPreview($(this).data('song'));
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

  var showSongPreview = function(song) {
    // wipe and populate drawer
    var drawer = $('.preview-drawer');

    drawer.find('.name, .artist, .tempo, .key, .chord-sheet')
      .html('');

    drawer.find('.name').text(song.name);
    drawer.find('.page-link').attr('href', '/songs/' + song.id);
    drawer.find('.chord-sheet').text(song.chord_sheet);
    drawer.find('.artist').text(song.artist);
    drawer.find('.tempo').text(song.tempo);
    drawer.find('.key').text(song.key);

    // highlight text matching the search query terms
    var keywords = $('#songs-search-field').val();
    var options = {
      element: 'span',
      caseSensitive: false,
      done: function(counter) {
        $('.preview-drawer').show();
      }
    }
    drawer.find('.name, .artist, .chord-sheet', '.preview-drawer').mark(keywords, options);
  }

});
