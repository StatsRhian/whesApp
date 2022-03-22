#' Definition of the WHES categories
#'
#' #' A vector containing the the 7 essential conditions

"essential_conditions"


#' Breakdown variables
#'
#' A vector containing the four breakdown variables
#'
#' \describe{
#' A vector listing the four possible breakdown variables
#' }
"breakdown_vars"

#' A dataset containing all the indicator data
#'
#' @format A tibble
#' \describe{
#'   \item{ind_id}{Unique id}
#'   \item{Sex}{Can be Male, Female or All}
#'   \item{Age}{Age category, varies depending indicator, can be "All"}
#'   \item{Deprivation}{Indicator of deprivation, varies depending on indicator, can be "All"}
#'   \item{Education}{Can be High, Medium, Low or All}
#'   \item{value}{The value of the data}
#'   \item{type}{Usually percent or rate}
#'   \item{ci_lower}{Lower confidence interval, NA if missing}
#'   \item{ci_upper}{Upper confidence interval, NA if missing}
#'   ...
#' }
"indicator_data"

#' A dataset containing short name, full name and icons for the
#' seven categories
#'
#' @format A tibble
#' \describe{
#'   \item{ind_id}{Unique id}
#'   \item{category}{The categorythe indicator belongs to}
#'   \item{name}{The indicator name}
#'   \item{source_id}{Short hand for the source}
#'   \item{disag}{List column describing which groupings are available}
#'   \item{type}{Usually percent or rate}
#'   ...
#' }
"indicator_info"

#' A dataset containing the translation database
#'
#' @format A tibble
#' \describe{
#'   \item{key}{short key}
#'   \item{EN}{The English phrase}
#'   \item{CY}{The Welsh phrase}
#'   ...
#' }
"translate_db"
