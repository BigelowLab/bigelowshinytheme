#' Copies www folder with supporting images and instruction CSS file to specified directory
#' @export
#' @param dest char, path to intended parent directory of www folder
#' @return results from file.copy
#' @examples
#' \dontrun{
#' if (!dir.exists("www")) {
#'  copy_www()
#' }
#' }
copy_www <- function(dest = getwd()) {
  if (!dir.exists(dest)) {stop("Destination directory does not exist.")}
  
  src <- system.file("www", package = "bigelowshinytheme")
  
  file.copy(src, dest, recursive = TRUE)
}
