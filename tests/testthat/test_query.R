context("query for versions")

first_query_hash <- "hash://sha256/2a5de79372318317a382ea9a2cef069780b852b01210ef59e06b640a3539cb5a"


test_that("translate a sha256 hash to a relative path", {
  expect_equal(hash_to_2level_path(first_query_hash), "2a/5d/2a5de79372318317a382ea9a2cef069780b852b01210ef59e06b640a3539cb5a")
})

test_that("translate a sha256 hash to a 0 level path", {
  expect_equal(hash_to_0level_path(first_query_hash), "2a5de79372318317a382ea9a2cef069780b852b01210ef59e06b640a3539cb5a")
})

test_that("a file can be retrieved from internet archive", {
  some_version <- query_internet_archive(first_query_hash)
  expect_equal(some_version, "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55")
})

test_that("a file can be retrieved from deeplinker", {
  some_version <- query_deep_linker(first_query_hash)
  expect_equal(some_version, "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55")
})
