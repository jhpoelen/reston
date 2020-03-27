#' Opens a stream (i.e., connection) to retrieve content associated with content_hash
#'
#'  @param content_hash content hash of requested content in hashuri format.
#'  @return stream (i.e., connection) of content
#'
#'  @export
#'
retrieve <- function(content_hash, hash2url = hash2url_ia_biodiversity_dataset_archive) {
  if (is_valid_hash(content_hash)) {
    query_url <- hash2url(content_hash)
    curl::curl(query_url, "rb")
  } else {
    stop(paste(content_hash, "is not a valid content hash"))
  }
}
