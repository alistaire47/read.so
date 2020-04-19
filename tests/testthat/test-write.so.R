context("write.so, write_so")

options(read.so.write_clip = FALSE)
tibble <- tibble::tibble
data.table <- data.table::data.table

test_that("expressions returned match original", {
    capture.output({    # stop printing
        expect_equal(eval(write.so(iris)), iris)
        expect_equal(
            eval(write_so(tibble::as_tibble(iris))),
            tibble::as_tibble(iris)
        )
        expect_equal(
            eval(write.so(data.table::as.data.table(iris))),
            data.table::as.data.table(iris)
        )
    })
})

test_that("running text output returns original", {
    expect_equal(
        eval(parse(text = paste(capture.output(write.so(iris)), collapse = ""))),
        iris
    )
})

test_that("text output respects arguments", {
    expect_output(write_so(tibble::as_tibble(iris)), "tibble\\(")
    expect_output(write.so(tibble::as_tibble(iris), tbl_fun = "tibble"), "tibble\\(")
    expect_output(write.so(iris), "    Species")
    expect_output(write.so(iris, indent = 2), "  Species")
})
