context("tabularify")

test_that("write table with url, hash uri and date accessed columns", {
  nquad_snippet <- c(
    "<http://tb.plazi.org/GgServer/dwca/C7570C54AE08FF83600FFFC2D77F8272.zip> <http://purl.org/dc/elements/1.1/format> \"application/dwca\" .",
    "<hash://sha256/f55bcfe2fecb108d11246b00ce3ba1a207db2b21a2f143f93e75be45299a66c1> <http://www.w3.org/ns/prov#generatedAtTime> \"2019-04-23T19:45:57.793Z\"^^<http://www.w3.org/2001/XMLSchema#dateTime> .",
    "<http://tb.plazi.org/GgServer/dwca/C7570C54AE08FF83600FFFC2D77F8272.zip> <http://purl.org/pav/hasVersion> <hash://sha256/f55bcfe2fecb108d11246b00ce3ba1a207db2b21a2f143f93e75be45299a66c1> ."
  )

  quads <- rdflib::rdf_parse(nquad_snippet, format="nquads")

  sparql <-
    'SELECT ?source_url ?content_uri ?generation_date
  WHERE {
    ?content_uri <http://www.w3.org/ns/prov#generatedAtTime> ?generation_date .
    ?source_url <http://purl.org/pav/hasVersion> ?content_uri .
  }'

  some_table <- rdflib::rdf_query(quads, sparql)
  expect_equal(some_table$content_uri, "hash://sha256/f55bcfe2fecb108d11246b00ce3ba1a207db2b21a2f143f93e75be45299a66c1")
  expect_equal(some_table$source_url, "http://tb.plazi.org/GgServer/dwca/C7570C54AE08FF83600FFFC2D77F8272.zip")
  expect_equal(as.Date(some_table$generation_date), as.Date("2019-04-23T19:45:57.793Z"))
})

