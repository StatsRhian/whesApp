$( document ).ready(function() {

  // Set page language
  function setPageLanguage(language) {
    $("html").attr("lang", language);
    updateTimeoutMessageLanguage(language);
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

  // Clear timeout message
  function clearTimeoutMessage(msg) {
    document.getElementById("timeout-warning").classList.add("d-none");
  }
  Shiny.addCustomMessageHandler("timeoutExtend", clearTimeoutMessage);

  // Warn that the page is about to disconnect after 14 minutes of inactivity
  var timeoutWarningMsecs = 14 * 60 * 1000;
  var idleTimer;

  function onTimeout() {
    document.getElementById("timeout-warning").classList.remove("d-none");
    document.getElementById("timeout_extend").focus();
  }

  function startIdleTimer() {
    if (idleTimer) clearTimeout(idleTimer);
    idleTimer = setTimeout(onTimeout, timeoutWarningMsecs);
    clearTimeoutMessage(true);
  }

  $(document).on('shiny:message shiny:inputchanged', startIdleTimer);

});

function updateTimeoutMessageLanguage(lang) {
  const timeout_message_en = "Your session is about to disconnect in less than 60 seconds due to inactivity.";
  const timeout_message_cy = "Mae eich sesiwn ar fin datgysylltu mewn llai na 60 eiliad oherwydd anweithgarwch.";

  const button_en = "Click to reload the page";
  const button_cy = "Cliciwch i barhau â'ch sesiwn";

  var timeout_text = lang === "cy" ? timeout_message_cy : timeout_message_en;
  var button_text = lang === "cy" ? button_cy : button_en;

  document.querySelector("#timeout-warning p").innerText = timeout_text;
  document.getElementById("timeout_extend").innerText = button_text;
}

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
