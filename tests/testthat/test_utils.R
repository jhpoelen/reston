context("utilities")

first_query_hash <- "hash://sha256/2a5de79372318317a382ea9a2cef069780b852b01210ef59e06b640a3539cb5a"

test_that("translate a sha256 hash to a relative path", {
  expect_equal(hash_to_2level_path(first_query_hash), "2a/5d/2a5de79372318317a382ea9a2cef069780b852b01210ef59e06b640a3539cb5a")
})

test_that("translate a sha256 hash to a 0 level path", {
  expect_equal(hash_to_0level_path(first_query_hash), "2a5de79372318317a382ea9a2cef069780b852b01210ef59e06b640a3539cb5a")
})

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

