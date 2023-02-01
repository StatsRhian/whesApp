#' Format the language code
#'
#' Takes language codes and formats them to be lowercase,
#' so they comply with ISO 639-1 Language Code standards.
#' Exceptions are for Chinese Simplified and Traditional,
#' with have longer codes that contain a capital letter.
#'
#' See \url{https://www.w3docs.com/learn-html/html-language-codes.html}
#' for a full list of ISO 639-1 codes.
#'
#' @param language Language code
#' @return Lowercase language code (except for certain
#' Chinese codes).
format_language_code = function(language) {
  lower_lang = tolower(language) # nolint: object_usage_linter.
  dplyr::case_when(
    lower_lang == "zh-hans" ~ "zh-Hans", # Chinese Simplified
    lower_lang == "zh-hant" ~ "zh-Hant", # Chinese Traditional
    TRUE ~ lower_lang
  )
}
