context("tsv_export")

extract_source_hash_rows <- function(lines, version_id, line_number_offset) {

  strip_brackets <- function(x) {
    gsub(">$", "", gsub("^<", "", x))
  }

  words <- unlist(strsplit(lines, "[ \n]"))
  statement_indexes <- grep("<http://www.w3.org/ns/prov#generatedAtTime>", words)

  content_id <- strip_brackets(words[statement_indexes-1])

  generated_at <- words[statement_indexes+1]
  date_str <- gsub("Z.*", "Z", generated_at)
  generated_at_value <- gsub("^\"", "", date_str)

  has_version <- grep("<http://purl.org/pav/hasVersion>", words)
  source_url <- strip_brackets(words[has_version-1])

  df <- as.data.frame(cbind(source_url, content_id, generated_at_value))
  names(df) <- c("source_url", "content_id", "generated_at")
  df
}


test_that("relative uris", {

  nquad_snippet <- c(
    "<http://tb.plazi.org/GgServer/dwca/C7570C54AE08FF83600FFFC2D77F8272.zip> <http://purl.org/dc/elements/1.1/format> \"application/dwca\" .",
    "<hash://sha256/f55bcfe2fecb108d11246b00ce3ba1a207db2b21a2f143f93e75be45299a66c1> <http://www.w3.org/ns/prov#generatedAtTime> \"2019-04-23T19:45:57.793Z\"^^<http://www.w3.org/2001/XMLSchema#dateTime> .",
    "<http://tb.plazi.org/GgServer/dwca/C7570C54AE08FF83600FFFC2D77F8272.zip> <http://purl.org/pav/hasVersion> <hash://sha256/f55bcfe2fecb108d11246b00ce3ba1a207db2b21a2f143f93e75be45299a66c1> ."
  )

  some_table <- extract_source_hash_rows(nquad_snippet, version_id = "foo", line_number_offset = 0)

  expect_equal(some_table$content_id[[1]], as.factor("hash://sha256/f55bcfe2fecb108d11246b00ce3ba1a207db2b21a2f143f93e75be45299a66c1"))
  expect_equal(some_table$source_url[[1]], as.factor("http://tb.plazi.org/GgServer/dwca/C7570C54AE08FF83600FFFC2D77F8272.zip"))
  expect_equal(as.Date(some_table$generated_at[[1]]), as.Date("2019-04-23T19:45:57.793Z"))
})
