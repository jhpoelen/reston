(work in progress) R package for using Preston observatories

![R-CMD-check](https://github.com/jhpoelen/reston/workflows/R-CMD-check/badge.svg)

Reston helps discover biodiversity dataset in [Preston](https://preston.guoda.bio) archives. Preston archives contain versions of provenance logs. Provenance logs uniquely identify tracked dataset versions along with the location they were retrieved from. Provenance logs are formatted as [rdf/nquads](https://www.w3.org/TR/n-quads/). 

Note that the [```iterators```](https://cran.r-project.org/package=iterators) R package is used to retrieve the provenance log version identifiers. Iterators are used because there may be many versions and it might take a while to retrieve all. A convenience method, ```reston::version_history()``` is provided to retrieve all versions at once.  

The following example writes the first two content identifiers and their source locations from the default [Preston archive at the Internet Archive](https://archive.org/details/biodiversity-dataset-archives) and writes it into a temporary connection. This connection is then read and printed. The function ```stream_provenance``` uses provenance version iterators (e.g., ```version_history_iter()```) in the background.  Note that the ```process_func()``` acts as a streaming query. In the example below a line-by-line filter is implemented, but this can be extended to include sufficiently (stateful) complex processing logic. 

```R
install.packages('remotes')
remotes::install_github("jhpoelen/reston")

# version id is the provenance log hash (e.g., hash://sha256/...
# line_number_offset is the line number in the current provenance version id
# the combination of version_id and line_number_offset reliably references 
# individual lines in the provenance log versions. 
filter_versions <- function(lines, version_id, line_number_offset) {
  # write only lines with hasVersion in it
  lines[grepl("hasVersion", lines)]
}

# open an temporary read/write connection
test_con <- fifo("", open = "w+b")

# attempt to write logs for first two versions
stream_provenance(con = test_con,
                 process_func = filter_versions,
                 n = 2)
actual_lines <- readLines(test_con)
close(test_con)
print(actual_lines)
```

The expected output is:

```
[1] "<https://search.idigbio.org/v2/search/publishers> <http://purl.org/pav/hasVersion> <hash://sha256/3eff98d4b66368fd8d1f8fa1af6a057774d8a407a4771490beeb9e7add76f362> ."
[2] "<https://api.gbif.org/v1/dataset> <http://purl.org/pav/hasVersion> <hash://sha256/184886cc6ae4490a49a70b6fd9a3e1dfafce433fc8e3d022c89e0b75ea3cda0b> ."
```

The provenance logs contains datasets versions for tracked dataset locations in the format:

```
<some url> <http://purl.org/pav/hasVersion> <some dataset id>
```

For instance:

```
<http://ipt.gbifbenin.org/archive.do?r=cnsf_niger> <http://purl.org/pav/hasVersion> <hash://sha256/d981008d7c7dddd827bcba16087a9c88cf233567d4751f67bb7f96e0756f2c9c> .
```

You'll find that the default Preston remote contains thousands of these dataset versions covering period Sept 2018 - Oct 2019. 

Please see the [reston tests](tests/testthat) for more examples on how to use this package.
