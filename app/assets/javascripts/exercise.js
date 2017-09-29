//Override the default confirm dialog by rails
$.rails.allowAction = function(link){
  if (link.data("confirm") == undefined){
    return true;
  }
  $.rails.showConfirmationDialog(link);
  return false;
}
//User click confirm button
$.rails.confirmed = function(link){
  link.data("confirm", null);
  link.trigger("click.rails");
}
//Display the confirmation dialog
$.rails.showConfirmationDialog = function(link){
  var message = link.data("confirm");
  $("#dialog-confirm").dialog({
    resizable: false,
    height: "auto",
    width: 400,
    modal: true,
    buttons: {
      "确定": function() {
        $(this).dialog("close");
        $.rails.confirmed(link);
      },
      "取消": function() {
        $(this).dialog("close");
      }
    }
  });
  $("#dialog-confirm-content").html(message);
  $("#dialog-confirm").dialog("open");
}

/* function fixxedtext() {
    if(navigator.appName.indexOf("Microsoft") != -1) {
        if(document.body.offsetWidth > 960) {
            var width = document.body.offsetWidth - 960;
            width = width / 2;
            document.getElementById("side").style.marginRight = width + "px";
        }
        if(document.body.offsetWidth < 960) {
            var width = 960 - document.body.offsetWidth;
            document.getElementById("side").style.marginRight = "-" + width + "px";
        }
    }
    else {
        if(window.innerWidth > 960) {
            var width = window.innerWidth - 960;
            width = width / 2;
            document.getElementById("side").style.marginRight = width + "px";
        }
        if(window.innerWidth < 960) {
            var width = 960 - window.innerWidth;
            document.getElementById("side").style.marginRight = "-" + width + "px";
        }
    }
    window.setTimeout("fixxedtext()", 2500)
  }
*/

jQuery("document").ready(function($){
  var side = $('#side');
  $(window).scroll(function () {
    if($(this).scrollTop() > 65) {
      side.addClass("f-side");
      } else {
        side.removeClass("f-side");
     }
  });
});



