$( document ).ready(function() {
  // Set page language
  function setPageLanguage(language) {
    $("html").attr("lang", language);
  }

  // Let Shiny server modify page language
  Shiny.addCustomMessageHandler("setLanguage", setPageLanguage);

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
