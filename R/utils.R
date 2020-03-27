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
