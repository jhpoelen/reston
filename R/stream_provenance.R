#' Streams processed provenance log into writable connection .
#'
#' @param con the connection (e.g., file) to write into after being processed by process_func
#' @param process_func a function that processes provenance lines
#' @param version_iter an provenance version iterator @seealso version_history_iter()
#' @param n maximum number of (processed) lines to write, -1 means unlimited
#' @param line_batch_size number of lines to be processed at once
#' @return number of written (processed) lines
#' @examples
#' \donttest{
#'  # open an temporary read/write connection
#'  con <- fifo("", open = "w+b")
#'  stream_provenance(con, n = 1)
#'  first_line_first_provenance_log <- readLines(con)
#'  close(con)
#'
#'  # open file
#'  con <- file("somefile.txt", open = "w+b")
#'  versions_only = function(lines) {
#'    lines[grepl("hasVersion", lines)]
#'  }
#'
#'  # save only provenance lines with "hasVersion" in it
#'  stream_provenance(con, process_func = versions_only, n = 1)
#'  first_version_in_provenance_log <- readLines(con)
#'
#'  close(con)
#' }
#'
#' @export
#'
stream_provenance <- function(con,
                                   process_func = function(x, version_id, line_number_offset) { x },
                                   version_iter = version_history_iter(),
                                   n = -1L,
                                   line_batch_size = 1) {

  process_provenance_log <- function(version_id, read_con, write_con, process_func, n = -1) {
    # read first line in provenance log
    max_lines_written <- n
    n_lines_written <- 0
    has_lines <- TRUE
    while (has_lines && n_lines_written < max_lines_written) {
      lines_read <- readLines(con = read_con, n = line_batch_size, encoding = "UTF-8")
      has_lines <- length(lines_read) == line_batch_size
      processed_lines <- process_func(lines_read,
                                      version_id = version_id,
                                      line_number_offset = n_lines_written)
      processed_lines_trunc <- utils::head(processed_lines, n = max_lines_written - n_lines_written)
      writeLines(processed_lines_trunc, write_con)
      n_lines_written <- n_lines_written + length(processed_lines_trunc)
    }
    n_lines_written
  }

  it <- itertools::ihasNext(version_iter)
  n_lines_written_total <- 0
  while (itertools::hasNext(it) && (n == -1 || n_lines_written_total < n)) {
    version_id <- iterators::nextElem(it)
    read_con <- retrieve_content(version_id)
    n_lines_written <- process_provenance_log(version_id = version_id,
                                              read_con = read_con,
                                              process_func,
                                              write_con = con,
                                              n = n)
    n_lines_written_total <- n_lines_written_total + n_lines_written
    close(read_con)
  }
  n_lines_written_total
}
