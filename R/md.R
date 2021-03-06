#' Read a markdown table into a data frame
#'
#' `read.md` and `read_md` are functions to read a markdown table into a
#' data.frame or tibble, respectively.
#'
#' The `file` parameter will accept a filepath or connection, but given that
#' these functions are built for interactive use, they are built to accept a
#' single string containing the data (distinguished from a filepath by the
#' presence of a newline) or a vector of lines, as may be generated by
#' [clipr::read_clip()].
#'
#' @return For `read.md`, a data.frame; for `read_md`, a tibble.
#'
#' @param file A path to a file, a connection, or literal data (either a single
#'     string or a vector of lines). If unspecified, reads from the clipboard.
#' @param delim A string to use as a column delimiter. For most markdown
#'     tables, this is the pipe: "|".
#' @param stringsAsFactors A logical value indicating whether to convert string
#'     columns to factors. Passed along to [read.delim()].
#' @param strip.white,trim_ws Trim leading and trailing whitespace from each
#'     column before parsing.
#' @param ... Passed along to [read.delim()] or [readr::read_delim()] by
#'     `read.md` and `read_md`, respectively. Applied after empty and
#'     markdown-only lines have been removed.
#'
#' @examples
#' read.md(
#' '+:--+--:+
#'  | x | y |
#'  +:==+==:+
#'  | 1 | 2 |
#'  | 3 | 4 |')
#'
#'read_md(
#' '| x | y |
#'  | 1 | 2 |
#'  | 3 | 4 |')
#'
#' @export
read.md <- function(file = clipr::read_clip(),
                    delim = '|',
                    stringsAsFactors = FALSE,
                    strip.white = TRUE,
                    ...){
    if (length(file) > 1) {
        lines <- file
    } else if (grepl('\n', file)) {
        con <- textConnection(file)
        lines <- readLines(con)
        close(con)
    } else {
        lines <- readLines(file)
    }
    lines <- lines[!grepl('^[\\:\\s\\+\\-\\=\\_\\|]*$', lines, perl = TRUE)]
    lines <- gsub('(^\\s*?\\|)|(\\|\\s*?$)', '', lines)
    utils::read.delim(text = paste(lines, collapse = '\n'), sep = delim,
                      stringsAsFactors = stringsAsFactors,
                      strip.white = strip.white, ...)
}

#' @rdname read.md
#' @export
read_md <- function(file = clipr::read_clip(),
                    delim = '|',
                    trim_ws = TRUE,
                    ...){
    if (length(file) > 1) {
        lines <- file
    } else {
        lines <- readr::read_lines(file)
    }
    lines <- lines[!grepl('^[\\:\\s\\+\\-\\=\\_\\|]*$', lines, perl = TRUE)]
    lines <- gsub('(^\\s*?\\|)|(\\|\\s*?$)', '', lines)
    readr::read_delim(paste(lines, collapse = '\n'), delim = delim,
                      trim_ws = trim_ws, ...)
}
