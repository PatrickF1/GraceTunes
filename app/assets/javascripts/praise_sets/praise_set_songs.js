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
      data: { song_id: $(this).data("song-id") }
    }).done(function(data){
      $("a[data-song-id=\""+data[0].id+"\"]").parents(".praise-set-song").slideToggle('slow');
    });
  });

  $(".praise-set-songs").sortable({
    sort: true,
    animation: 500,
    draggable: ".praise-set-song",
    handle: ".fa-bars",
    ghostClass: "drop-placeholder",
    onUpdate: function(e){
      $.ajax({
        url: $(e.item).find(".drag-handle").data("set-position-path"),
        method: "PUT",
        data: { song_id: $(e.item).find(".drag-handle").data("song-id"), new_position: e.newIndex }
      }).done(function(data){
        console.log("updated song position");
      });
    }
  });

});

var clearSelect = function(){
  $(".song-select").val(null).trigger("change");
}