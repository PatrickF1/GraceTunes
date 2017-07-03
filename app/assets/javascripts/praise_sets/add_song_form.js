$(function(){
  $songSelect = $(".song-select").select2({
    placeholder: "Select the song you want to add to this praise set",
    theme: "bootstrap"
  });

  $songSelect.on("select2:select", function(e){
    $.ajax({
      url: $songSelect.data("path"),
      method: "PUT",
      data: { song_id: e.params.data.id }
    }).done(function(data){
      $(".praise-set-songs").append($(data).hide().fadeIn());
    });
  });

  $(".praise-set-songs").on("click", ".remove-song", function(e){
    e.preventDefault();
    $.ajax({
      url: $(this).data("path"),
      method: "PUT",
      data: { song_id: $(this).data("song-id") }
    }).done(function(data){
      $("a[data-song-id=\""+data[0].id+"\"]").parents(".praise-set-song").slideToggle('slow');
    });
  })
});