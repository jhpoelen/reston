(work in progress) R package for using Preston observatories

![R-CMD-check](https://github.com/jhpoelen/reston/workflows/R-CMD-check/badge.svg)

Reston helps discover biodiversity dataset in [Preston](https://preston.guoda.bio) archives. Preston archives contain versions of provenance logs. Provenance logs uniquely identify tracked dataset versions along with the location they were retrieved from. Provenance logs are formatted as [rdf/nquads](https://www.w3.org/TR/n-quads/). 

Note that the [```iterators```](https://cran.r-project.org/package=iterators) R package is used to retrieve the provenance log version identifiers. Iterators are used because there may be many versions and it might take a while to retrieve all. A convenience method, ```reston::version_history()``` is provided to retrieve all versions at once.  

The following example discovers the first two provenance log versions from the default [Preston archive at the Internet Archive](https://archive.org/details/biodiversity-dataset-archives). The first line of each provenance log versions are printed to stdout.  

```R
install.packages('remotes')
remotes::install_github("jhpoelen/reston")

# create a default provenance log version iterator
version_iter <- reston::version_history_iter()
it <- itertools::ihasNext(version_iter)

counter <- 0L

while (itertools::hasNext(it) && counter < 2) {
  version_id <- iterators::nextElem(it)
  
  # retrieve a provenance log version
  prov_con <- reston::retrieve_content(version_id)

  # read the first line
  first_line <- readLines(con = prov_con, n = 1)

  print(paste0("first line for version_id [", version_id, "] is:"))
  # write first line from provenance log into connection "test_con"
  writeLines(first_line, stdout())
  
  close(prov_con)

  counter <- counter + 1
}
```
The expected output is:

```
[1] "first line for version_id [hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55] is:"
<https://preston.guoda.org> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/ns/prov#SoftwareAgent> .
[1] "first line for version_id [hash://sha256/b83cf099449dae3f633af618b19d05013953e7a1d7d97bc5ac01afd7bd9abe5d] is:"
<https://preston.guoda.org> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/ns/prov#SoftwareAgent> .
```

The provenance logs contains datasets versions for tracked dataset urls in the format:

```
<some url> <http://purl.org/pav/hasVersion> <some dataset id>
```

For instance:

```
<http://ipt.gbifbenin.org/archive.do?r=cnsf_niger> <http://purl.org/pav/hasVersion> <hash://sha256/d981008d7c7dddd827bcba16087a9c88cf233567d4751f67bb7f96e0756f2c9c> .
```

You'll find that the default Preston remote contains thousands of these dataset versions.

Please see the [reston tests](tree/master/tests/testthat) for more examples on how to use this package.
