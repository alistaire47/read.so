context("read.str, read_str, read.glimpse, read_glimpse")

# these don't seem to do what they should, regardless of where they're passed
strOptions(strict.width = "cut")
options(width = 80)

capture.output(str(iris), file = "iris.str.txt")
capture.output(tibble::glimpse(iris, width = 80), file = "iris_glimpse.txt")

sample <- tibble::tibble(x = list(47))



test_that("str file input can be read", {
    expect_equivalent(read.str('iris.str.txt'), head(iris, 10))
    expect_equivalent(read_str('iris.str.txt'), head(iris, 10))
})

test_that("str text input can be read", {
    expect_equivalent(read.str(capture.output(str(tibble::as_tibble(iris)))),
                      head(tibble::as_tibble(iris), 10))
    expect_equivalent(read.str(paste(capture.output(str(iris)), collapse = "\n")),
                      head(iris, 10))
    expect_equivalent(read.str(capture.output(str(ChickWeight))),
                      ChickWeight[NULL, ])
    expect_equivalent(read.str(capture.output(str(sample))),
                      tibble::tibble(x = c('of', '1')))    # worth improving?
})

test_that("glimpse file input can be read", {
    expect_equivalent(read.glimpse('iris_glimpse.txt'), head(iris, 7))
    expect_equivalent(read_glimpse('iris_glimpse.txt'),
                      head(tibble::as_tibble(iris), 7))
})

test_that("glimpse text input can be read", {
    expect_equivalent(
        read_glimpse(capture.output(tibble::glimpse(Orange, width = 80))),
        head(tibble::as_tibble(Orange), 10)
    )
    expect_equivalent(read_glimpse(capture.output(tibble::glimpse(sample))),
                      tibble::tibble(x = '[47]'))
})

quoted_df <- tibble::data_frame(x = rep('test", "test', 10))
test_that("quoted strings are well-handled", {
    expect_equivalent(
        read_glimpse(capture.output(tibble::glimpse(quoted_df, width = 47))),
        quoted_df[1:2, ]
    )
    expect_equivalent(
        read_glimpse(capture.output(tibble::glimpse(quoted_df, width = 56))),
        quoted_df[1:2, ]
    )
})

unlink("iris.str.txt")
unlink("iris_glimpse.txt")
