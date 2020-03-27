#' Returns an answer to a query hash
#'
#' Internally, an answer is retrieved by appending the relative path
#' of the query hash provided by hash2path to the url endpoint:
#'
#' [url endpoint]/[query hash path]
#'
#' where query hash path = hash2path(query_hash)
#'
#' @query_hash query_hash explicitly specify version to start with
#' @url_endpoint location of local (e.g., file://) or remote preston archive
#' @hash2path function that maps a query hash to a relative url path
#' @return an answer in the form a content hash
#' @examples
#' \donttest{
#'  first_version <- query("hash://sha256/2a5de79372318317a382ea9a2cef069780b852b01210ef59e06b640a3539cb5a")
#'  # "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55"
#' }
#'  @seealso https://github.com/bio-guoda/preston/blob/master/architecture.md#simplified-hexastore#'
#'  @seealso https://preston.guoda.bio
#'
query <- function(query_hash = first_version_query_hash(),
                  url_endpoint = query_internet_archive,
                  hash2path = hash_to_2level_path()) {
  hash_candidate <- ''
  if (is_valid_hash(query_hash)) {
    hash_path <- hash2path(query_hash)
    query_url <- paste0(url_endpoint, hash_path)
    con <- curl::curl(query_url, "rb")
    bin <- readBin(con, raw(), 79)
    close(con)
    hash_candidate <- enc2utf8(rawToChar(bin))
  }
  hash_candidate
}

#' Returns answer to query hash as provided by Preston remote at
#' https://archive.org/download/biodiversity-dataset-archives/data.zip/data/

#' @query_hash query_hash explicitly specify version to start with
#' @return an answer in the form a content hash
#' @examples
#' \donttest{
#'  first_version <- query_deep_linker("hash://sha256/2a5de79372318317a382ea9a2cef069780b852b01210ef59e06b640a3539cb5a")
#'  # "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55"
#' }
#' @seealso https://archive.org/download/biodiversity-dataset-archives/data.zip/data/
#'
query_internet_archive <- function(query_hash = first_version_query_hash()) {
  query(query_hash,
          url_endpoint = "https://archive.org/download/biodiversity-dataset-archives/data.zip/data/",
          hash2path = hash_to_2level_path)
}

#' Returns answer to query hash as provided by Preston remote at
#' https://deeplinker.bio
#'
#' @query_hash query_hash explicitly specify version to start with
#' @return an answer in the form a content hash
#' @examples
#' \donttest{
#'  first_version <- query_deep_linker("hash://sha256/2a5de79372318317a382ea9a2cef069780b852b01210ef59e06b640a3539cb5a")
#'  # "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55"
#' }
#'  @seealso https://github.com/bio-guoda/preston/blob/master/architecture.md#simplified-hexastore#'
#'

query_deep_linker <- function(query_hash = first_version_query_hash()) {
  query(query_hash,
          url_endpoint = "https://deeplinker.bio/",
          hash2path = hash_to_0level_path)
}

