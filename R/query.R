query <- function(query_hash, url_endpoint, hash2path = hash_to_2level_path) {
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

#' resolves a (query) hash to biodiversity datasets in internet archive
query_internet_archive <- function(query_hash) {
  query(query_hash,
          url_endpoint = "https://archive.org/download/biodiversity-dataset-archives/data.zip/data/",
          hash2path = hash_to_2level_path)
}

query_deep_linker <- function(query_hash) {
  query(query_hash,
          url_endpoint = "https://deeplinker.bio/",
          hash2path = hash_to_0level_path)
}

