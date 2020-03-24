context("retrieve version history")

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

is_valid_hash <- function(hash) {
  ifelse(length(grep("hash://sha256/[0-9a-z]{64}", hash)) == 0, FALSE, TRUE)
}

version_history <- function(retrieve) {
  versions <- function(version_history) {
    last_version <- version_history[[length(version_history)]]
    next_version_candidate <- retrieve(next_version_query_hash(last_version))
    if(is_valid_hash(next_version_candidate)) {
      versions(append(version_history, next_version_candidate))
    } else {
      version_history
    }
  }
  first_version <- retrieve(first_version_query_hash())
  versions(list(first_version))
}

test_that("hash uri is valid", {
  expect_true(is_valid_hash("hash://sha256/a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3"))
})

test_that("hash uri is invalid", {
  expect_false(is_valid_hash("bla"))
})


test_that("can calculate a sha256 hash", {
  hash <- sha256_uri("123")
  expect_identical(
    hash,
    "hash://sha256/a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3"
  )
})

test_that("can traverse a preston provenance history", {



  expect_identical(
    first_version_query_hash(),
    "hash://sha256/2a5de79372318317a382ea9a2cef069780b852b01210ef59e06b640a3539cb5a"
  );
})

test_that("can calculate next preston provenance version", {
  expect_identical(
    next_version_query_hash("hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55"),
    "hash://sha256/7ebb008412baaac3afcc8af68b796bf4ca98f367cfd61a815eee82cdffeab196"
  );
})

test_that("can calculate another next version", {
  expect_identical(
    next_version_query_hash("hash://sha256/b83cf099449dae3f633af618b19d05013953e7a1d7d97bc5ac01afd7bd9abe5d"),
    "hash://sha256/1707cb11cd9f696f1a86fd06742c1e14fad856747be88791f79f6fc7c979d5a6"
  );
})

test_that("retrieve a sequence of versions", {
  query_hash_first <- "hash://sha256/2a5de79372318317a382ea9a2cef069780b852b01210ef59e06b640a3539cb5a"
  query_hash_second <- "hash://sha256/7ebb008412baaac3afcc8af68b796bf4ca98f367cfd61a815eee82cdffeab196"
  query_hash_third <- "hash://sha256/1707cb11cd9f696f1a86fd06742c1e14fad856747be88791f79f6fc7c979d5a6"

  retrieve <- function(hash) {
      switch(hash,
        "hash://sha256/2a5de79372318317a382ea9a2cef069780b852b01210ef59e06b640a3539cb5a" = "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55",
        "hash://sha256/7ebb008412baaac3afcc8af68b796bf4ca98f367cfd61a815eee82cdffeab196" = "hash://sha256/b83cf099449dae3f633af618b19d05013953e7a1d7d97bc5ac01afd7bd9abe5d",
        "hash://sha256/1707cb11cd9f696f1a86fd06742c1e14fad856747be88791f79f6fc7c979d5a6" = "hash://sha256/7efdea9263e57605d2d2d8b79ccd26a55743123d0c974140c72c8c1cfc679b93"
      )
  };
  query <- function(query_hash, retrieve) {
    retrieve(query_hash)
  }

  expect_identical(query(query_hash_first, retrieve),
                   "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55")
  expect_identical(query(query_hash_second, retrieve),
                   "hash://sha256/b83cf099449dae3f633af618b19d05013953e7a1d7d97bc5ac01afd7bd9abe5d")
  expect_identical(query(query_hash_third, retrieve),
                   "hash://sha256/7efdea9263e57605d2d2d8b79ccd26a55743123d0c974140c72c8c1cfc679b93")



  some_versions <- version_history(retrieve)

  expect_identical(some_versions[[1]], "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55")
  expect_identical(some_versions[[2]], "hash://sha256/b83cf099449dae3f633af618b19d05013953e7a1d7d97bc5ac01afd7bd9abe5d")
  expect_identical(some_versions[[3]], "hash://sha256/7efdea9263e57605d2d2d8b79ccd26a55743123d0c974140c72c8c1cfc679b93")

  expect_equal(length(some_versions), 3)


})

