#' This function shouldn't be called directly, but instead used as an output
#' type in an Rmd file's frontmatter
#' @param keep_tex Boolean whether or not to keep .tex files generated
#' @export

report = function(keep_tex = FALSE) {
  template = system.file("rmarkdown", "templates", "report", "resources", "template.tex",
              package = "whesApp",
              mustWork = TRUE)

  rmarkdown::pdf_document(
    template = template,
    keep_tex = keep_tex,
    toc = TRUE
  )

}
