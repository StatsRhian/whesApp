$( document ).ready(function() {
  'use strict';

  function browserSupportsInert() {
    const div = document.createElement('div');
    return 'inert' in div;
  }

  function makeInert($el) {
    if (browserSupportsInert()) {
      $el.attr('inert', '');
    }
    else {
      $el.css('display', 'none');
    };
  }

  function makeActive($el) {
    if (browserSupportsInert()) {
      $el.removeAttr('inert');
    }
    else {
      $el.css('display', "");
    };
  }

  function shinyAlert(message) {
    alert(message);
  }

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

  // Disconnection message due to timeout or internal error
  $(document).on('shiny:disconnected', function () {
  $("#timeout-warning").addClass("d-none");

  const dialog = $("#ss-connect-dialog")
    .empty()
    .attr('role', 'alert')
    .removeAttr('id')
    .addClass('dialog');

  makeInert($('main'));

  const lang = $("html").attr("lang");
  let pText, buttonText;

  if (lang === 'cy') {
      pText = "Mae eich sesiwn wedi'i ddatgysylltu oherwydd terfyn amser sesiwn neu wall mewnol";
      buttonText = "Cliciwch i ail-lwytho'r dudalen";
    }
    else {
      pText = "Your session has been disconnected due to a timeout because of 15 minutes of inactivity, or an internal error.";
      buttonText = "Click to reload the page";
    }

    $('<p>').text(pText).appendTo(dialog);

    $('<button>').text(buttonText)
      .appendTo(dialog)
      .on('click', () => window.location.reload())
      .focus();
  });


  let oldFocus;

  function clearIdleWarning(_) {
    makeActive($('main'));
    $('#ss-overlay').css('display', 'none');
    $('#timeout-warning').addClass('d-none');
    if (oldFocus) $(oldFocus).focus();
  }

  // Warning due to inactivity after 14 minutes
  Shiny.addCustomMessageHandler("clearTimeout", clearIdleWarning);

  const idleTimeout = 14 * 60 * 1000;
  let idleTimer;


  function launchIdleWarning() {
    oldFocus = document.activeElement;
    makeInert($('main'));
    $('#ss-overlay').css('display', 'block');
    const dialog = $('#timeout-warning').removeClass('d-none');

    const lang = $("html").attr("lang");
    let pText, buttonText;

    if (lang === 'cy') {
      pText = "Mae eich sesiwn ar fin datgysylltu mewn llai na 60 eiliad oherwydd anweithgarwch.";
      buttonText = "Cliciwch i barhau â'ch sesiwn";
    }
    else {
      pText = "Your session is about to disconnect in less than 60 seconds due to inactivity.";
      buttonText = "Click to continue with your session";
    }

    dialog.find('p').text(pText);
    dialog.find('button').text(buttonText).focus();
  }


  function startIdleTimer() {
    if (idleTimer) { clearTimeout(idleTimer); }
    idleTimer = setTimeout(launchIdleWarning, idleTimeout);
    clearIdleWarning(true);
  }

  $(document).on('shiny:message shiny:inputchanged', startIdleTimer);

  startIdleTimer();
});
