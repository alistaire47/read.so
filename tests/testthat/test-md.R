context("read.md, read_md")

sample_md <- tibble::tibble(
    char = c("a", "a", "b", "c"),
    int = c(1, 2, 3, 47),
    dbl = c(0.1, 0.23, 456, 7.8),
    date = as.Date(c("1970-01-01", "1901-12-31", "2000-01-01", "2017-01-15"))
)

sample.md <- as.data.frame(sample_md)
sample.md$date <- as.character(sample.md$date)

capture.output(knitr::kable(sample_md, 'markdown'), file = 'sample.md')


test_that("files can be read", {
    expect_equivalent(read.md("sample.md"), sample.md)
    expect_equivalent(read_md("sample.md"), sample_md)
})

sample_lines <- readLines("sample.md")

test_that("text input can be read", {
    expect_equivalent(read.md(sample_lines), sample.md)
    expect_equivalent(read.md(paste(sample_lines, collapse = "\n")), sample.md)
    expect_equivalent(read_md(sample_lines), sample_md)
})

unlink('sample.md')
