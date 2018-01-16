context("test_md")

sample.md <- structure(
    list(char = c("a", "a", "b", "c"),
         int = c(1L, 2L, 3L, 47L),
         dbl = c(0.1, 0.23, 456, 7.8),
         date = c("1970-01-01", "0001-12-31", "2000-01-01", "2017-01-15")),
    .Names = c("char", "int", "dbl", "date"), class = "data.frame",
    row.names = c(NA, -4L))

sample_md <- structure(
    list(char = c("a", "a", "b", "c"),
         int = c(1, 2, 3, 47),
         dbl = c(0.1, 0.23, 456, 7.8),
         date = structure(c(0, -718798, 10957, 17181), class = "Date")),
    .Names = c("char", "int", "dbl", "date"), row.names = c(NA, -4L),
    class = c("tbl_df", "tbl", "data.frame"),
    spec = structure(list(cols = structure(list(
        char = structure(list(), class = c("collector_character", "collector")),
        int = structure(list(), class = c("collector_double", "collector")),
        dbl = structure(list(), class = c("collector_double", "collector")),
        date = structure(list(format = ""), .Names = "format",
                         class = c("collector_date", "collector"))),
        .Names = c("char", "int", "dbl", "date")),
        default = structure(list(), class = c("collector_guess", "collector"))),
        .Names = c("cols", "default"), class = "col_spec"))

test_that("files can be read", {
    expect_equal(read.md('sample.md'), sample.md)
    expect_equal(read_md('sample.md'), sample_md)
})
