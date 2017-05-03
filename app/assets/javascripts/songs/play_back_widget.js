var PlayBackWidget = function() {
  this.trackList = {};
}

PlayBackWidget.prototype.search = function(song, callback) {
  if (this.trackList[song.id]) return callback(this.trackList[song.id]);

  // Example query string: "https://api.spotify.com/v1/search?q=artist:kari+jobe%20track:hands+to+the+heavens&type=track&market=US&limit=1"
  var uri;
  var self = this;
  var query = 'https://api.spotify.com/v1/search?q=';
  query += 'track:' + song.name.split(' ').join('+');
  if (song.artist)
    query += '%20artist:' + song.artist.split(' ').join('+');

  query += '&type=track&market=US&limit=5';

  $.ajax({
    url: query,
    dataType: 'json'
  }).done(function(data) {
    var validTracks = $.grep(data.tracks.items, function(track, i) {
      return self._validateTrack(track, song);
    });

    if (validTracks.length) {
      uri = validTracks[0].uri;
      self.trackList[song.id] = uri;
    }

    callback(uri);
  }).fail(function(a, b, c) {
    callback(uri);
  });
}

PlayBackWidget.prototype.load = function(selector, song) {
  this.search(song, function(uri) {
    if (uri) {
      var widget = document.createElement('iframe');
      widget.frameborder = 0;
      widget.allowtransparency = true;
      widget.height = 80;
      widget.width = 300;
      widget.src = 'https://open.spotify.com/embed?theme=white&uri=' + uri;

      $(selector).append(widget);
    } else {
      $(selector).text('An error ocurred while trying to load the song preview.')
    }
  });

  PlayBackWidget.prototype._validateTrack = function(trackResult, song) {
    if (song.artist && trackResult.artists.length &&
        song.artist.toLowerCase() !== trackResult.artists[0].name.toLowerCase()) {
      console.log(song.artist, 'did not match result', trackResult.artist);
      return false;
    }

    return true;
  }
}
