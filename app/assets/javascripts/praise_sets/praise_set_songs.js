var clearSelect = function(){
  $('.song-select').val(null).trigger("change");
}

$(function(){
  $songSelect = $('.song-select').select2({
    placeholder: "Select the song you want to add to this praise set",
    allowClear: true,
    theme: "bootstrap"
  });

  $songSelect.on('select2:select', function(e){
    $.ajax({
      url: "/songs/" + e.params.data.id + "/praise_set_song_partial",
      method: "GET",
    }).done(function(data){
      $('.praise-set-songs').append($(data).hide().fadeIn());
      clearSelect();
    });
  });

  clearSelect();

  $('.praise-set-songs').on("click", ".remove-song", function(e){
    e.preventDefault();
    $(this).parents(".praise-set-song").remove();
  });

  $('.praise-set-songs').sortable({
    sort: true,
    animation: 250,
    draggable: ".praise-set-song",
    handle: ".fa-bars",
    ghostClass: "ghost",
    chosenClass: "chosen"
  });
});