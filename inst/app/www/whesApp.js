$( document ).ready(function() {
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
