context("so")

iris_head <- structure(list(
    Sepal.Length = c(5.1, 4.9, 4.7, 4.6, 5, 5.4, 4.6, 5, 4.4, 4.9),
    Sepal.Width = c(3.5, 3, 3.2, 3.1, 3.6, 3.9, 3.4, 3.4, 2.9, 3.1),
    Petal.Length = c(1.4, 1.4, 1.3, 1.5, 1.4, 1.7, 1.4, 1.5, 1.4, 1.5),
    Petal.Width = c(0.2, 0.2, 0.2, 0.2, 0.2, 0.4, 0.3, 0.2, 0.2, 0.1),
    Species = c("setosa", "setosa", "setosa", "setosa", "setosa", "setosa",
                "setosa", "setosa", "setosa", "setosa")),
    .Names = c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "Species"),
    class = "data.frame",
    row.names = c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10"))

iris_head_tibble <- structure(list(
    Sepal.Length = c(5.1, 4.9, 4.7, 4.6, 5, 5.4, 4.6, 5, 4.4, 4.9),
    Sepal.Width = c(3.5, 3, 3.2, 3.1, 3.6, 3.9, 3.4, 3.4, 2.9, 3.1),
    Petal.Length = c(1.4, 1.4, 1.3, 1.5, 1.4, 1.7, 1.4, 1.5, 1.4, 1.5),
    Petal.Width = c(0.2, 0.2, 0.2, 0.2, 0.2, 0.4, 0.3, 0.2, 0.2, 0.1),
    Species = c("setosa", "setosa", "setosa", "setosa", "setosa", "setosa",
                "setosa", "setosa", "setosa", "setosa")),
    .Names = c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "Species"),
    row.names = c(NA, -10L), class = c("tbl_df", "tbl", "data.frame"),
    spec = structure(list(cols = structure(list(
        Sepal.Length = structure(list(), class = c("collector_double", "collector")),
        Sepal.Width = structure(list(), class = c("collector_double", "collector")),
        Petal.Length = structure(list(), class = c("collector_double", "collector")),
        Petal.Width = structure(list(), class = c("collector_double", "collector")),
        Species = structure(list(), class = c("collector_character", "collector"))),
        .Names = c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "Species")),
        default = structure(list(), class = c("collector_guess", "collector"))),
        .Names = c("cols", "default"), class = "col_spec"))

test_that("can read files", {
    expect_equal(read.so('iris.txt'), iris_head)
    expect_equal(read_so('iris.txt'), iris_head_tibble)
    expect_equal(read_so('iris-tibble.txt'), iris_head_tibble)
})
