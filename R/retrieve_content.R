#' Opens a stream (i.e., connection) to retrieve content associated with content_hash
#'
#' @param content_hash content hash of requested content
#' @param hash2url function that maps a content hash to a url
#' @return a stream (i.e., connection) of requested content
#' @examples
#' \donttest{
#'  con <- retrieve_content(query())
#'  first_line <- readLines(con, 1)
#'  close(con)
#'  # first line should start with <https://preston.guoda...
#' }
#'
#' @export
#'
retrieve_content <- function(content_hash, hash2url = hash2url_ia_biodiversity_dataset_archive) {
  if (is_valid_hash(content_hash)) {
    query_url <- hash2url(content_hash)
    url(query_url, "rb")
  } else {
    stop(paste(content_hash, "is not a valid content hash"))
  }
}
