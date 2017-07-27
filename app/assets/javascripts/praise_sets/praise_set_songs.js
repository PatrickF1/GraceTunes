var clearSelect = function(){
  $(".song-select").val(null).trigger("change");
}

$(function(){
  $songSelect = $(".song-select").select2({
    placeholder: "Select the song you want to add to this praise set",
    allowClear: true,
    theme: "bootstrap"
  });

  $songSelect.on("select2:select", function(e){
    $.ajax({
      url: $songSelect.data("path"),
      method: "PUT",
      data: { song_id: e.params.data.id }
    }).done(function(data){
      $(".praise-set-songs").append($(data).hide().fadeIn());
      clearSelect();
    });
  });

  clearSelect();

  $(".praise-set-songs").on("click", ".remove-song", function(e){
    e.preventDefault();
    $.ajax({
      url: $(this).data("path"),
      method: "PUT",
      data: { praise_set_song_id: $(this).data("praise-set-song-id") }
    }).done(function(data){
      $("a[data-praise-set-song-id=\""+data[0].id+"\"]").parents(".praise-set-song").slideToggle('slow');
    });
  });

  $(".praise-set-songs").sortable({
    sort: true,
    animation: 250,
    draggable: ".praise-set-song",
    handle: ".fa-bars",
    ghostClass: "ghost",
    chosenClass: "chosen",
    onUpdate: function(e){
      $.ajax({
        url: $(e.item).find(".song_dragIcon").data("set-position-path"),
        method: "PUT",
        data: { praise_set_song_id: $(e.item).find(".song_dragIcon").data("praise-set-song-id"), new_position: e.newIndex }
      }).done(function(data){
        console.log("updated song position");
      });
    }
  });

});