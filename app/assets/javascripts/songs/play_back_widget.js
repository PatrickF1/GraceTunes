var PlayBackWidget = function() {
  this.trackList = {}; // keep the last 100 tracks
}

PlayBackWidget.prototype.search = function(song, callback) {
  if (this.trackList[song.id]) return callback(this.trackList[song.id]);

  // Example query: "https://api.spotify.com/v1/search?q=artist:kari+jobe%20track:hands+to+the+heavens&type=track&market=US&limit=1"
  var uri;
  var query = 'https://api.spotify.com/v1/search?q=';
  query += 'track:' + song.name.split(' ').join('+');
  if (song.artist)
    query += '%20artist:' + song.artist.split(' ').join('+');

  query += '&type=track&market=US&limit=1';

  $.ajax({
    url: query,
    dataType: 'json'
  }).done(function(data) {
    if (data.tracks.items.length) {
      uri = data.tracks.items[0].uri; // blindly return the first track, even if it's non existant
    }

    callback(uri);
  }).fail(function(a, b, c) {
    alert('failed!');
  });
}

PlayBackWidget.prototype.load = function(selector, song) {
  this.search(song, function(uri) {
    var widget = document.createElement('iframe');
    widget.frameborder = 0;
    widget.allowtransparency = true;
    widget.height = 80;
    widget.width = 300;
    widget.src = 'https://open.spotify.com/embed?theme=white&uri=' + uri;

    $(selector).append(widget);
  });
}
