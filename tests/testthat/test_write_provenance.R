context("write processed provenance")

test_that("write content identifiers for resource locations", {
  filter_versions <- function(lines, ...) {
    # write only lines with hasVersion in it
    lines[grepl("hasVersion", lines)]
  }

  # open an temporary read/write connection
  test_con <- fifo("", open = "w+b")

  # attempt to write logs for first two versions
  write_provenance(version_iter = version_history_iter(),
                         con = test_con,
                         process_func = filter_versions,
                         n = 2)

  actual_lines <- readLines(test_con)
  close(test_con)
  expect_equal(length(actual_lines), 2)
  expect_equal(length(unique(actual_lines)), 2)

  expected_first_line <- "<https://search.idigbio.org/v2/search/publishers> <http://purl.org/pav/hasVersion> <hash://sha256/3eff98d4b66368fd8d1f8fa1af6a057774d8a407a4771490beeb9e7add76f362> ."
  expected_last_line <- "<https://api.gbif.org/v1/dataset> <http://purl.org/pav/hasVersion> <hash://sha256/184886cc6ae4490a49a70b6fd9a3e1dfafce433fc8e3d022c89e0b75ea3cda0b> ."

  expect_equal(head(actual_lines, n=1L), expected_first_line)
  expect_equal(tail(actual_lines, n=1L), expected_last_line)
})

