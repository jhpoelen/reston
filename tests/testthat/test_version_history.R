
context("version history")

query_test <- function(hash) {
  switch(hash,
         "hash://sha256/2a5de79372318317a382ea9a2cef069780b852b01210ef59e06b640a3539cb5a" = "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55",
         "hash://sha256/7ebb008412baaac3afcc8af68b796bf4ca98f367cfd61a815eee82cdffeab196" = "hash://sha256/b83cf099449dae3f633af618b19d05013953e7a1d7d97bc5ac01afd7bd9abe5d",
         "hash://sha256/1707cb11cd9f696f1a86fd06742c1e14fad856747be88791f79f6fc7c979d5a6" = "hash://sha256/7efdea9263e57605d2d2d8b79ccd26a55743123d0c974140c72c8c1cfc679b93"
  )
};

test_that("prov version iter returns all versions", {
  prov_iter <- version_history_iter(query = query_test)
  actual_versions <- as.list(prov_iter)
  expect_equal(actual_versions[[1]], "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55")
  expect_equal(actual_versions[[2]], "hash://sha256/b83cf099449dae3f633af618b19d05013953e7a1d7d97bc5ac01afd7bd9abe5d")
  expect_equal(actual_versions[[3]], "hash://sha256/7efdea9263e57605d2d2d8b79ccd26a55743123d0c974140c72c8c1cfc679b93")
  expect_equal(length(actual_versions), 3);
})

test_that("prov version iterate", {
  prov_iter <- version_history_iter(query = query_test)
  next_version <- iterators::nextElem(prov_iter)
  expect_equal(next_version, "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55")
  next_version <- iterators::nextElem(prov_iter)
  expect_equal(next_version, "hash://sha256/b83cf099449dae3f633af618b19d05013953e7a1d7d97bc5ac01afd7bd9abe5d")
  next_version <- iterators::nextElem(prov_iter)
  expect_equal(next_version, "hash://sha256/7efdea9263e57605d2d2d8b79ccd26a55743123d0c974140c72c8c1cfc679b93")

  expect_error(iterators::nextElem(prov_iter), "StopIteration");
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

  expect_identical(query_test(query_hash_first),
                   "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55")
  expect_identical(query_test(query_hash_second),
                   "hash://sha256/b83cf099449dae3f633af618b19d05013953e7a1d7d97bc5ac01afd7bd9abe5d")
  expect_identical(query_test(query_hash_third),
                   "hash://sha256/7efdea9263e57605d2d2d8b79ccd26a55743123d0c974140c72c8c1cfc679b93")

  some_versions <- version_history(query = query_test)

  expect_identical(some_versions[[1]], "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55")
  expect_identical(some_versions[[2]], "hash://sha256/b83cf099449dae3f633af618b19d05013953e7a1d7d97bc5ac01afd7bd9abe5d")
  expect_identical(some_versions[[3]], "hash://sha256/7efdea9263e57605d2d2d8b79ccd26a55743123d0c974140c72c8c1cfc679b93")

  expect_equal(length(some_versions), 3)

})
