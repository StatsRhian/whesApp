$( document ).ready(function() {
  Shiny.addCustomMessageHandler("disable_download_button", function(params) {
    $("#" + params[0])
      .removeClass("btn-default")
      .addClass("btn-info")
      .html("<i class=\"fas fa-circle-notch fa-spin\"></i> " + params[1]);
  });
  Shiny.addCustomMessageHandler("enable_download_button", function(params) {
    $("#" + params[0])
      .removeClass("btn-info")
      .addClass("btn-default")
      .html("<i class=\"fas fa-download\"></i> " + params[1]);
  });
});
