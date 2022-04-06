.onLoad = function(libname, pkgname) {
  sysfonts::font_add(family = "fontawesome-webfont",
                     regular = system.file("app", "www", "fonts", "fontawesome-webfont.ttf",
                                           package = "whesApp"))
  showtext::showtext_auto()
}
