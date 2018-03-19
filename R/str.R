
parsers <- tibble::tribble(
    ~class,                  ~parser,       ~str,   ~glimpse,
    'character',            identity,        'chr',    'chr',
    'logical',  readr::parse_logical,       'logi',    'lgl',
    'integer',  readr::parse_integer,        'int',    'int',
    'numeric',   readr::parse_double,        'num',    'dbl',
    # 'matrix'    # classed as above, but with '[...]' in str (nothing in glance)
    'factor',                 factor,     'Factor',    'fct',    # str a mess
    'ordered',               ordered, 'Ord.factor',    'ord',    # has two classes; str a mess
    'Date',        readr::parse_date,       'Date',   'date',
    'POSIXct', readr::parse_datetime,    'POSIXct',   'dttm',    # has 2 classes; str has ', format'
    'POSIXlt',            as.POSIXlt,    'POSIXlt',   'dttm',    # has 2 classes; str has ', format'; indistinguishable from POSIXct in glimpse
    'hms',         readr::parse_time,         'hms',   'time'#,    # has 2 classes; str a mess,
    # 'list',                    list,        'list',   'list',    # complicated
    # more possiblities? language objects, raw vectors
)

#' Read the results of `str.data.frame` back into a data frame
#'
#' `read.str` and `read_str` read the structure printed
#' when [utils::str.data.frame()] back into a data frame.
#'
#' `read.str` and `read_str` are roughly inverses of `str.data.frame`, except:
#'
#' - `read.str` subsets to rows where the `str` results contain the complete
#' data for the observation,
#' - attributes are dropped, and
#' - list and matrix columns are unsupported.
#'
#' Classes at the top of the `str` results are reassigned, so both vanilla
#' `data.frame`s and variants like `tbl_df` and `data.table` are supported.
#' Because class is determined by the data, `read_str` is merely an alias.
#'
#' @inheritParams read.so
#'
#' @return A data frame of the class specified in the first line of input.
#'
#' @examples
#' read.str(capture.output(str(iris)))
#'
#' # Resulting class is determined by input, not read.str vs. read_str
#' read_str(capture.output(str(tibble::as_tibble(iris))))
#'
#' @export
read.str <- function(file = readr::clipboard()){
    if (length(file) == 1) {
        lns <- readr::read_lines(file)
    } else {
        lns <- file
    }

    df_cls <- gsub('^Classes | and |[,"\'\u2018\u2019]|:.*$', ' ', lns[1])
    df_cls <- scan(text = df_cls, what = character(), quiet = TRUE)

    lns <- lns[grep('^\\s*\\$', lns)]    # ignores attributes
    lns <- gsub('\\s*\\$\\s*|\\s*\\.+\\s*$', '', lns)
    nms <- sub('\\s*:.*', '', lns)
    lns <- sub('^.*?:\\s+', '', lns)

    is_fac <- grepl('^Factor|^Ord.factor', lns)

    var_cls <- character(length(lns))
    var_cls[is_fac] <- sub(':.*?$', '', lns[is_fac])    # levels still need parsing
    lns[is_fac] <- sub('.*:\\s*', '', lns[is_fac])
    var_cls[!is_fac] <- sub('^(\\S*).*', '\\1', lns[!is_fac])
    lns[!is_fac] <- sub('^\\S*\\s*', '', lns[!is_fac])

    dat <- lapply(lns, function(x){
        scan(text = x, what = character(), quiet = TRUE)
    })
    dat <- lapply(dat, `[`, seq(min(lengths(dat))))    # subset to complete rows

    # parse and reinsert levels
    if (any(is_fac)) {
        lvl <- gsub('.*levels?\\s*|[,<]\\.{2}', '', var_cls[is_fac])
        var_cls[is_fac] <- sub('\\s*w/.*', '', var_cls[is_fac])

        lvl <- Map(function(cl, lv){
            scan(text = lv,
                 what = character(),
                 sep = ifelse(grepl('Ord', cl), '<', ','),
                 quiet = TRUE)
        }, var_cls[is_fac], lvl)

        # drop rows with missing levels
        dat[is_fac] <- lapply(dat[is_fac], as.integer)
        i_in_dat <- Reduce(`&`, Map(function(dt, lv){
            dt <= length(lv)
        }, dat[is_fac], lvl))
        dat <- lapply(dat, `[`, i_in_dat)
        dat[is_fac] <- Map(function(dt, lv){
            lv[as.integer(dt)]
        }, dat[is_fac], lvl)
    }

    prs <- lapply(var_cls, function(x){parsers$parser[x == parsers$str]})
    dat <- Map(
        function(p, d){
            if (length(p) == 0) {    # if no parser found, guess
                utils::type.convert(d, as.is = TRUE)
            } else {
                p[[1]](d)
            }
        },
        prs, dat)

    structure(
        dat,
        names = nms,
        row.names = c(NA, length(dat[[1]])),
        class = df_cls
    )
}

#' @rdname read.str
#' @export
read_str <- read.str


#' Read the results of `tibble::glimpse` back into a data frame
#'
#' `read_glimpse` and `read.glimpse` read the data printed
#' by [tibble::glimpse()] back into a data frame.
#'
#' `read_glimpse` and `read.glimpse` are roughly inverses of `tibble::glimpse`,
#' except:
#'
#' - they subset to rows where the input contains the complete data for the
#' observation,
#' - list and matrix columns are unsupported and may lead to unexpected
#' behavior, and
#' - since `glimpse` does not provide attributes or data frame classes,
#'   - attributes are dropped, and
#'   - class is assigned as supplied when called, defaulting to a tibble for
#'   `read_glimpse` and a data.frame for `read.glimpse`.
#'
#' @inheritParams read.so
#' @param class A character vector of classes to assign to the results.
#'
#' @return A data frame of the class specified by the `class` parameter.
#'
#' @examples
#' x <- capture.output(tibble::glimpse(iris))
#'
#' read_glimpse(x)
#'
#' read.glimpse(x)
#'
#' @export
read_glimpse <- function(file = readr::clipboard(),
                         class = c("tbl_df", "tbl", "data.frame")){
    if (length(file) == 1) {
        lns <- readr::read_lines(file)
    } else {
        lns <- file
    }

    lns <- lns[grep('\\s*\\$', lns)]
    lns <- gsub('^\\s*\\$\\s*|,\\s*\\S*\\.+\\s*$', '', lns)
    nms <- sub('\\s*<.*$', '', lns)
    cls <- sub('.*<(\\w+)>.*', '\\1', lns)
    lns <- sub('.*>\\s*', '', lns)

    dat <- lapply(lns, function(x){
        # will fail with factors with commas in levels, because glimpse does
        scan(text = x, what = character(), sep = ',', strip.white = TRUE, quiet = TRUE)
    })
    dat <- lapply(dat, `[`, seq(min(lengths(dat))))    # subset to complete rows

    prs <- lapply(cls, function(x){parsers$parser[x == parsers$glimpse]})
    dat <- Map(
        function(p, d){
            if (length(p) == 0) {    # if no parser found, guess
                utils::type.convert(d, as.is = TRUE)
            } else {
                p[[1]](d)
            }
        },
        prs, dat)

    structure(
        dat,
        names = nms,
        row.names = c(NA, length(dat[[1]])),
        class = class
    )
}

#' @rdname read_glimpse
#' @export
read.glimpse <- function(file = readr::clipboard(),
                         class = "data.frame"){
    read_glimpse(file = file, class = class)
}
