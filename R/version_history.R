#' Iterator for preston version history starting with oldest version.
#'
#' @param query_hash query_hash explicitly specify version to start with
#' @param query a function that takes a query hash and returns a content hash
#' @return iterator to access versions, starting with the oldest
#' @examples
#' \donttest{
#'  version_iter <- version_history_iter(resolve_internet_archive)
#'  first_version <- nextElem(version_iter)
#'  # "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55"
#' }
#'

version_history_iter <- function(query_hash = first_version_query_hash(),
                                 query = query_internet_archive) {
  nextEl <- function() {
    candidate_version <- query(query_hash)
    if (is_valid_hash(candidate_version)) {
      query_hash <<- next_version_query_hash(candidate_version)
      candidate_version
    } else {
      stop('StopIteration')
    }
  }

  obj <- list(nextElem = nextEl)
  class(obj) <- c('abstractiter','iter')
  obj
}

#' List preston version history starting with oldest version.
#'
#' Please use version_history_iter for incrementally retrieving version.
#'
#' @param query_hash query_hash explicitly specify version to start with
#' @param query a function that takes a query hash and returns a content hash
#' @return list of versions, starting with the oldest
#' @examples
#' \donttest{
#'  version_list <- version_history(query_internet_archive)
#'  head(version_list)
#'  # "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55"
#' }
#'
version_history <- function(query_hash = first_version_query_hash(),
                            query = query_internet_archive) {
  as.list(version_history_iter(query_hash = query_hash, query = query))
}
