$(function() {
  $('#audit_action').change(function(){
    $.ajax({
      url: "/audits",
      data: { audit_action: $('#audit_action').val() }
    }).done(function(data){
      $('.audits').html(data);
    });
  });
})