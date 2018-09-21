#' Write a text representation of a data frame
#'
#' `write.so` writes a call to produce the specified data frame to the console
#' or a specified connection. The function used to recreate the data frame in
#' the output is determined by the class of the input. `write_so` is an alias.
#'
#' @param x A data frame to write.
#' @param file A connection or filename to which to print; passed to [`cat`].
#' @param write_clip Logical. Write result to clipboard?
#' @param indent The number of spaces by which to indent column definitions.
#' @param tbl_fun The character function name to use to create tibbles, either
#'     `"data_frame"` or `"tibble"`. Ignored for other cases.
#'
#' @return Prints the call to produce the input to the specified connection;
#'     returns the call invisibly.
#'
#' @examples
#' write.so(head(iris))
#'
#' @export
write.so <- function(x, file = stdout(), write_clip = TRUE,
                     indent = 4, tbl_fun = c("data_frame", "tibble")){
    tbl_fun <- match.arg(tbl_fun)

    dput_string <- paste(utils::capture.output(dput(x)), collapse = " ")
    dput_string <- gsub("(<.*?>)", '"\\1"', dput_string)    # quote pointers
    dput_call <- parse(text = dput_string)

    df_class <- eval(dput_call[[1]]$class)
    if ("tbl" %in% df_class) {
        df_fun <- tbl_fun
    } else {
        df_fun <- df_class[[1]]    # for data.tables
    }

    df_call <- dput_call[[1]][[2]]
    df_call[[1]] <- as.name(df_fun)

    indent <- paste(rep(" ", indent), collapse = "")

    # deparse column vectors individually
    cols <- vapply(
        df_call[-1],
        function(col){
            col_text <- paste(deparse(col), collapse = "")
            gsub("\\s+", " ", col_text)    # remove tabs
        },
        character(1)
    )
    # collapse deparsed columns to single string
    cols <- paste(names(cols), cols, sep = " = ", collapse = paste0(",\n", indent))
    # re-add data.frame call
    df_text <- paste0(df_fun, "(\n", indent, cols, "\n)")

    cat(df_text, file = file)

    if (write_clip) {
        clipr::write_clip(df_text)
    }

    invisible(df_call)
}

#' @rdname write.so
#' @export
write_so <- write.so
