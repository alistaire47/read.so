<!-- README.md is generated from README.Rmd. Please edit that file -->
read.so
=======

[![Travis-CI Build Status](https://travis-ci.org/alistaire47/read.so.svg?branch=master)](https://travis-ci.org/alistaire47/read.so) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/alistaire47/read.so?branch=master&svg=true)](https://ci.appveyor.com/project/alistaire47/read.so) [![Coverage Status](https://img.shields.io/codecov/c/github/alistaire47/read.so/master.svg)](https://codecov.io/github/alistaire47/read.so?branch=master) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/read.so)](https://cran.r-project.org/package=read.so)

### Installation

read.so is not on CRAN, but you can install it with

``` r
# install.packages("devtools")
devtools::install_github("alistaire47/read.so")
```

Read Tables from Stack Overlow Questions into R
-----------------------------------------------

Sometimes you see a really interesting question on Stack Overlow, but the asker only presents the data as a presentation-style table instead of as runnable R code. Fear no more! `read.so` will read even the most heinous tables into a data frame in a trice.

### Read data frame print output back into R

For instance, should you want to return output copied from the R console back into your own session, use `read.so` for a data.frame, and `read_so` for a tibble. Pass in a filepath, a raw string of text, a vector of lines, or if the data is on the clipboard, nothing at all, and the functions will grab it for you:

``` r
library(read.so)

iris_lines <- capture.output(head(iris))

iris_lines
#> [1] "  Sepal.Length Sepal.Width Petal.Length Petal.Width Species"
#> [2] "1          5.1         3.5          1.4         0.2  setosa"
#> [3] "2          4.9         3.0          1.4         0.2  setosa"
#> [4] "3          4.7         3.2          1.3         0.2  setosa"
#> [5] "4          4.6         3.1          1.5         0.2  setosa"
#> [6] "5          5.0         3.6          1.4         0.2  setosa"
#> [7] "6          5.4         3.9          1.7         0.4  setosa"

read.so(iris_lines)
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
#> 3          4.7         3.2          1.3         0.2  setosa
#> 4          4.6         3.1          1.5         0.2  setosa
#> 5          5.0         3.6          1.4         0.2  setosa
#> 6          5.4         3.9          1.7         0.4  setosa

read_so(iris_lines)
#> # A tibble: 6 x 5
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#>          <dbl>       <dbl>        <dbl>       <dbl> <chr>  
#> 1         5.10        3.50         1.40       0.200 setosa 
#> 2         4.90        3.00         1.40       0.200 setosa 
#> 3         4.70        3.20         1.30       0.200 setosa 
#> 4         4.60        3.10         1.50       0.200 setosa 
#> 5         5.00        3.60         1.40       0.200 setosa 
#> 6         5.40        3.90         1.70       0.400 setosa

clipr::write_clip(head(iris))

read.so()
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
#> 3          4.7         3.2          1.3         0.2  setosa
#> 4          4.6         3.1          1.5         0.2  setosa
#> 5          5.0         3.6          1.4         0.2  setosa
#> 6          5.4         3.9          1.7         0.4  setosa
```

Further, `read_so` will attempt to read in the results of printing a tibble:

``` r
mtcars_lines <- capture.output(readr::read_csv(readr::readr_example("mtcars.csv")))

mtcars_lines
#>  [1] "# A tibble: 32 x 11"                                                 
#>  [2] "     mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb"
#>  [3] "   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>"
#>  [4] " 1  21.0  6.00   160 110    3.90  2.62  16.5  0     1.00  4.00  4.00"
#>  [5] " 2  21.0  6.00   160 110    3.90  2.88  17.0  0     1.00  4.00  4.00"
#>  [6] " 3  22.8  4.00   108  93.0  3.85  2.32  18.6  1.00  1.00  4.00  1.00"
#>  [7] " 4  21.4  6.00   258 110    3.08  3.22  19.4  1.00  0     3.00  1.00"
#>  [8] " 5  18.7  8.00   360 175    3.15  3.44  17.0  0     0     3.00  2.00"
#>  [9] " 6  18.1  6.00   225 105    2.76  3.46  20.2  1.00  0     3.00  1.00"
#> [10] " 7  14.3  8.00   360 245    3.21  3.57  15.8  0     0     3.00  4.00"
#> [11] " 8  24.4  4.00   147  62.0  3.69  3.19  20.0  1.00  0     4.00  2.00"
#> [12] " 9  22.8  4.00   141  95.0  3.92  3.15  22.9  1.00  0     4.00  2.00"
#> [13] "10  19.2  6.00   168 123    3.92  3.44  18.3  1.00  0     4.00  4.00"
#> [14] "# ... with 22 more rows"

read_so(mtcars_lines)
#> # A tibble: 10 x 11
#>      mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
#>    <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#>  1  21.0  6.00   160 110    3.90  2.62  16.5  0     1.00  4.00  4.00
#>  2  21.0  6.00   160 110    3.90  2.88  17.0  0     1.00  4.00  4.00
#>  3  22.8  4.00   108  93.0  3.85  2.32  18.6  1.00  1.00  4.00  1.00
#>  4  21.4  6.00   258 110    3.08  3.22  19.4  1.00  0     3.00  1.00
#>  5  18.7  8.00   360 175    3.15  3.44  17.0  0     0     3.00  2.00
#>  6  18.1  6.00   225 105    2.76  3.46  20.2  1.00  0     3.00  1.00
#>  7  14.3  8.00   360 245    3.21  3.57  15.8  0     0     3.00  4.00
#>  8  24.4  4.00   147  62.0  3.69  3.19  20.0  1.00  0     4.00  2.00
#>  9  22.8  4.00   141  95.0  3.92  3.15  22.9  1.00  0     4.00  2.00
#> 10  19.2  6.00   168 123    3.92  3.44  18.3  1.00  0     4.00  4.00
```

### Read Markdown tables into R

read.so can also read Markdown tables into R:

``` r
chick_lines <- capture.output(
    knitr::kable(head(ChickWeight), format = "markdown")
)

cat(chick_lines, sep = "\n")
#> 
#> 
#> | weight| Time|Chick |Diet |
#> |------:|----:|:-----|:----|
#> |     42|    0|1     |1    |
#> |     51|    2|1     |1    |
#> |     59|    4|1     |1    |
#> |     64|    6|1     |1    |
#> |     76|    8|1     |1    |
#> |     93|   10|1     |1    |

read.md(chick_lines)
#>   weight Time Chick Diet
#> 1     42    0     1    1
#> 2     51    2     1    1
#> 3     59    4     1    1
#> 4     64    6     1    1
#> 5     76    8     1    1
#> 6     93   10     1    1

read_md(chick_lines)
#> # A tibble: 6 x 4
#>   weight  Time Chick  Diet
#>    <dbl> <dbl> <dbl> <dbl>
#> 1   42.0  0     1.00  1.00
#> 2   51.0  2.00  1.00  1.00
#> 3   59.0  4.00  1.00  1.00
#> 4   64.0  6.00  1.00  1.00
#> 5   76.0  8.00  1.00  1.00
#> 6   93.0 10.0   1.00  1.00
```

It can handle a number of formats, including tables with delimiter rows composed of "-", "=", "+", and whitespace.
