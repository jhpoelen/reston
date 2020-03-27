

#' Returns an answer to a query hash
#'
#' Internally, an answer is retrieved by appending the relative path
#' of the query hash provided by hash2path to the url endpoint:
#'
#' https://example.org/hash/path
#'
#' where:
#'  * https://example.org/ is the url endpoint
#'  * some/path is the query hash path generated from query hash by hash2path
#'
#' @param query_hash query_hash explicitly specify version to start with, by default, the first version is queried.
#' @param hash2url function that maps a query hash to a url
#' @return an answer in the form a content hash
#' @examples
#' \donttest{
#'  first_version <- query()
#'  # "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55"
#' }
#'
#' @seealso <https://github.com/bio-guoda/preston/blob/master/architecture.md#simplified-hexastore#>
#' @seealso <https://archive.org/details/biodiversity-dataset-archives>
#' @seealso <https://preston.guoda.bio>
#'
query <- function(query_hash = first_version_query_hash(),
                  hash2url = hash2url_ia_biodiversity_dataset_archive) {
  hash_candidate <- ''
  if (is_valid_hash(query_hash)) {
    query_url <- hash2url(query_hash)
    con <- curl::curl(query_url, "rb")
    # an answer should be a sha256 hash uri of length 78
    bin <- readBin(con, raw(), 78)
    close(con)
    hash_candidate <- enc2utf8(rawToChar(bin))
  }
  hash_candidate
}

#' Returns answer to query hash as provided by Preston remote at
#' https://archive.org/download/biodiversity-dataset-archives/data.zip/data/

#' @param query_hash query_hash explicitly specify version to start with
#' @return an answer in the form a content hash
#' @examples
#' \donttest{
#'  first_version <- query_deep_linker()
#'  # "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55"
#' }
#' @seealso https://archive.org/details/biodiversity-dataset-archives
#'
query_internet_archive <- function(query_hash = first_version_query_hash()) {
  query(query_hash,
          hash2url = hash2url_ia_biodiversity_dataset_archive)
}

#' Returns answer to query hash as provided by Preston remote at
#' https://deeplinker.bio
#'
#' @param query_hash query_hash explicitly specify version to start with
#' @return an answer in the form a content hash
#' @examples
#' \donttest{
#'  first_version <- query_deep_linker()
#'  # "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55"
#' }
#'
#'

query_deep_linker <- function(query_hash = first_version_query_hash()) {
  query(query_hash,
          hash2url = hash2url_deeplinker)
}

