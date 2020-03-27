# version_history
#
# Lists of the version history of a preston archive.
#
# Learn more about preston at:
#
#   https://preston.guoda.bio
#

sha256_uri <- function(x) {
  hash <- openssl::sha256(x)
  paste0("hash://sha256/", vapply(hash, as.character, character(1L)))
}

first_version_query_hash <- function() {
  biodiversity_dataset_graph <- "0659a54f-b713-4f86-a917-5be166a14110"

  sha256_uri(
    paste0(
      sha256_uri(biodiversity_dataset_graph),
      sha256_uri("http://purl.org/pav/hasVersion")
    )
  )
}

next_version_query_hash <- function(prov_hash_uri) {
  sha256_uri(
    paste0(
      sha256_uri("http://purl.org/pav/previousVersion"),
      sha256_uri(prov_hash_uri)
    )
  )
}

#' Iterator for preston version history starting with oldest version.
#'
#' @param query a function that takes a query hash and returns a content hash
#' @query_hash query_hash explicitly specify version to start with
#' @return iterator to access versions, starting with the oldest
#' @examples
#' \donttest{
#'  version_iter <- version_history_iter(resolve_internet_archive)
#'  first_version <- nextElem(version_iter)
#'  # "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55"
#' }
#' Learn more about preston at:
#'
#'   https://preston.guoda.bio
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
#' @param query a function that takes a query hash and returns a content hash
#' @query_hash query_hash explicitly specify version to start with
#' @return list of versions, starting with the oldest
#' @examples
#' \donttest{
#'  version_list <- version_history(query_internet_archive)
#'  head(version_list)
#'  # "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55"
#' }
#' Learn more about preston at:
#'
#'   https://preston.guoda.bio
#'
version_history <- function(query = query_internet_archive) {
  as.list(version_history_iter(query = query))
}
