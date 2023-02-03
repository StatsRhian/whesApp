$( document ).ready(function() {

  // Set page language
  function setPageLanguage(language) {
    $("html").attr("lang", language);
  }

  // Let Shiny server modify page language
  Shiny.addCustomMessageHandler("setLanguage", setPageLanguage);

  // Let Shiny server update page title
  Shiny.addCustomMessageHandler('changetitle', function(x) {
    document.title = x
  });

  // Make hyperlinks open in new tabs.
  new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
      $('a')
        .filter('[href^="http"], [href^="//"]')
        .not('[href*="' + window.location.host + '"]')
        .attr('rel', 'nofollow noopener noreferrer')
        .attr('target', '_blank');
    });
  }).observe(
    $(".tab-content")[0],
    { childList: true, subtree:true }
  );
});

// When the server disconnects the session, print a more descriptive message.
$(document).on('shiny:disconnected', function(event) {
  const discon_label_en = "Your session has been disconnected due to a timeout because of 15 minutes of inactivity, or an internal error.";
  const discon_label_cy = "Mae eich sesiwn wedi'i ddatgysylltu oherwydd terfyn amser sesiwn neu wall mewnol";

  const reload_en = "Click to reload the page";
  const reload_cy = "Cliciwch i ail-lwytho'r dudalen";

  var current_lang = $("html").attr("lang");
  var discon_label_text = current_lang === "cy" ? discon_label_cy : discon_label_en;
  var reload_text = current_lang === "cy" ? reload_cy : reload_en;

  document.querySelector("#ss-connect-dialog label").innerText = discon_label_text;
  document.getElementById("ss-reload-link").innerText = reload_text;

  // Make the dialog an "alert" for screen-readers and grab focus onto reload link
  document.getElementById("ss-connect-dialog").setAttribute("role", "alert");
  document.getElementById("ss-reload-link").focus();
});
