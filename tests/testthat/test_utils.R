context("utilities")

first_query_hash <- "hash://sha256/2a5de79372318317a382ea9a2cef069780b852b01210ef59e06b640a3539cb5a"

test_that("translate a sha256 hash to a relative path", {
  expect_equal(hash_to_2level_path(first_query_hash), "2a/5d/2a5de79372318317a382ea9a2cef069780b852b01210ef59e06b640a3539cb5a")
})

test_that("translate a sha256 hash to a 0 level path", {
  expect_equal(hash_to_0level_path(first_query_hash), "2a5de79372318317a382ea9a2cef069780b852b01210ef59e06b640a3539cb5a")
})
