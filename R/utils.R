hash_to_2level_path <- function(sha256_hash) {
  hash <- substr(sha256_hash, 15, 79)
  first_two <- substr(sha256_hash, 15, 16)
  second_two <- substr(sha256_hash, 17, 18)
  paste0(first_two, "/", second_two, "/", hash)
}

hash_to_0level_path <- function(sha256_hash) {
  substr(sha256_hash, 15, 79)
}

is_valid_hash <- function(hash) {
  ifelse(length(grep("hash://sha256/[0-9a-z]{64}", hash)) == 0, FALSE, TRUE)
}

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

ia_biodiversity_dataset_archive_url <- "https://archive.org/download/biodiversity-dataset-archives/data.zip/data/"
