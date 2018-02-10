context("read.so, read_so")

data("iris")
iris$Species <- as.character(iris$Species)

iris.head <- head(iris, 10)
iris_head <- head(tibble::as_tibble(iris), 10)

capture.output(iris.head, file = 'iris.head.txt')
capture.output(iris_head, file = 'iris_head.txt')

test_that("files can be read", {
    expect_equivalent(read.so("iris.head.txt"), iris.head)
    expect_equivalent(read_so("iris.head.txt"), iris_head)
    expect_equivalent(read_so("iris_head.txt"), iris_head)
})

iris.lines <- readLines("iris.head.txt")
iris_lines <- readLines("iris_head.txt")

test_that("text input can be read", {
    expect_equivalent(read.so(iris.lines), iris.head)
    expect_equivalent(read_so(iris_lines), iris_head)
})

unlink('iris.head.txt')
unlink('iris_head.txt')
