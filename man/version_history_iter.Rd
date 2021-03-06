% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/version_history.R
\name{version_history_iter}
\alias{version_history_iter}
\title{Iterator for preston version history starting with oldest version.}
\usage{
version_history_iter(query_hash = first_version_query_hash(),
  query = query_internet_archive)
}
\arguments{
\item{query_hash}{query_hash explicitly specify version to start with}

\item{query}{a function that takes a query hash and returns a content hash}
}
\value{
iterator to access versions, starting with the oldest
}
\description{
Iterator for preston version history starting with oldest version.
}
\examples{
\donttest{
 version_iter <- version_history_iter(resolve_internet_archive)
 first_version <- nextElem(version_iter)
 # "hash://sha256/c253a5311a20c2fc082bf9bac87a1ec5eb6e4e51ff936e7be20c29c8e77dee55"
}

}
