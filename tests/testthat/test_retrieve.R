context("retrieve content")

test_that("a file can be retrieved from internet archive", {
  con <- retrieve("hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55")
  lines <- readLines(con, 1)
  expected = paste("<https://preston.guoda.org>", "<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>",
        "<http://www.w3.org/ns/prov#SoftwareAgent>",".")
  expect_equal(lines[[1]], expected)
  close(con)
})
