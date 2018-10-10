
<!-- README.md is generated from README.Rmd. Please edit that file -->

# read.so

[![Travis-CI Build
Status](https://travis-ci.org/alistaire47/read.so.svg?branch=master)](https://travis-ci.org/alistaire47/read.so)
[![AppVeyor Build
status](https://ci.appveyor.com/api/projects/status/17mg5b1yd926krpk?svg=true)](https://ci.appveyor.com/project/alistaire47/read-so)
[![Coverage
Status](https://img.shields.io/codecov/c/github/alistaire47/read.so/master.svg)](https://codecov.io/github/alistaire47/read.so?branch=master)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/read.so)](https://cran.r-project.org/package=read.so)

### Installation

read.so is not on CRAN, but you can install it by running

``` r
install.packages("devtools")
devtools::install_github("alistaire47/read.so")
```

-----

## Read data from Stack Overflow questions into R

Sometimes you see a really interesting question on Stack Overflow (or a
Github issue, or [RStudio Community](https://community.rstudio.com/)),
but the asker only presents the data as a presentation-style table
instead of as runnable R code, because they, unlike you, don’t use
[reprex](http://reprex.tidyverse.org/). Fear no more\! read.so will read
even heinous tables into data frames and code in a trice.

### Read data frame print output back into a data frame

For instance, should you want to return output copied from the R console
back into your own session, use `read.so` for a data.frame, and
`read_so` for a tibble. Pass in a filepath, a raw string of text, a
vector of lines, or if the data is on the clipboard, nothing at all, and
the functions will grab it for you:

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
#> 1          5.1         3.5          1.4         0.2 setosa 
#> 2          4.9         3            1.4         0.2 setosa 
#> 3          4.7         3.2          1.3         0.2 setosa 
#> 4          4.6         3.1          1.5         0.2 setosa 
#> 5          5           3.6          1.4         0.2 setosa 
#> 6          5.4         3.9          1.7         0.4 setosa

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

Further, `read_so` will attempt to read in the results of printing a
tibble:

``` r
mtcars_lines <- capture.output(tibble::as_tibble(mtcars))

mtcars_lines
#>  [1] "# A tibble: 32 x 11"                                                 
#>  [2] "     mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb"
#>  [3] "   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>"
#>  [4] " 1  21       6  160    110  3.9   2.62  16.5     0     1     4     4"
#>  [5] " 2  21       6  160    110  3.9   2.88  17.0     0     1     4     4"
#>  [6] " 3  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1"
#>  [7] " 4  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1"
#>  [8] " 5  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2"
#>  [9] " 6  18.1     6  225    105  2.76  3.46  20.2     1     0     3     1"
#> [10] " 7  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4"
#> [11] " 8  24.4     4  147.    62  3.69  3.19  20       1     0     4     2"
#> [12] " 9  22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2"
#> [13] "10  19.2     6  168.   123  3.92  3.44  18.3     1     0     4     4"
#> [14] "# … with 22 more rows"

read_so(mtcars_lines)
#> # A tibble: 10 x 11
#>      mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
#>    <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#>  1  21       6   160   110  3.9   2.62  16.5     0     1     4     4
#>  2  21       6   160   110  3.9   2.88  17       0     1     4     4
#>  3  22.8     4   108    93  3.85  2.32  18.6     1     1     4     1
#>  4  21.4     6   258   110  3.08  3.22  19.4     1     0     3     1
#>  5  18.7     8   360   175  3.15  3.44  17       0     0     3     2
#>  6  18.1     6   225   105  2.76  3.46  20.2     1     0     3     1
#>  7  14.3     8   360   245  3.21  3.57  15.8     0     0     3     4
#>  8  24.4     4   147    62  3.69  3.19  20       1     0     4     2
#>  9  22.8     4   141    95  3.92  3.15  22.9     1     0     4     2
#> 10  19.2     6   168   123  3.92  3.44  18.3     1     0     4     4
```

### Read Markdown tables into data frames

When you need to read Markdown tables into R, read.so has you covered
with `read.md` and `read_md`:

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
#> 1     42     0     1     1
#> 2     51     2     1     1
#> 3     59     4     1     1
#> 4     64     6     1     1
#> 5     76     8     1     1
#> 6     93    10     1     1
```

They can handle a number of formats, including tables with delimiter
rows composed of “-”, “=”, “+”, and whitespace.

### Read `str` results back into a data frame

If all you have is the results of calling `str` on a data frame,
`read.str` will read as many complete rows as possible into a new data
frame of the same class as the original:

``` r
warp_lines <- capture.output(str(warpbreaks))

warp_lines
#> [1] "'data.frame':\t54 obs. of  3 variables:"                                  
#> [2] " $ breaks : num  26 30 54 25 70 52 51 26 67 18 ..."                       
#> [3] " $ wool   : Factor w/ 2 levels \"A\",\"B\": 1 1 1 1 1 1 1 1 1 1 ..."      
#> [4] " $ tension: Factor w/ 3 levels \"L\",\"M\",\"H\": 1 1 1 1 1 1 1 1 1 2 ..."

read.str(warp_lines)
#>    breaks wool tension
#> 1      26    A       L
#> 2      30    A       L
#> 3      54    A       L
#> 4      25    A       L
#> 5      70    A       L
#> 6      52    A       L
#> 7      51    A       L
#> 8      26    A       L
#> 9      67    A       L
#> 10     18    A       M
```

### Read `tibble::glimpse` results back into a data frame

Similarly, if the data was printed by `tibble::glimpse`, try
`read.glimpse` or
`read_glimpse`:

``` r
states <- data.frame(state.name, state.abb, state.region, state.division, 
                     state.area, center = state.center, state.x77)

states_lines <- capture.output(tibble::glimpse(states))

states_lines
#>  [1] "Observations: 50"                                                         
#>  [2] "Variables: 15"                                                            
#>  [3] "$ state.name     <fct> Alabama, Alaska, Arizona, Arkansas, California, C…"
#>  [4] "$ state.abb      <fct> AL, AK, AZ, AR, CA, CO, CT, DE, FL, GA, HI, ID, I…"
#>  [5] "$ state.region   <fct> South, West, West, South, West, West, Northeast, …"
#>  [6] "$ state.division <fct> East South Central, Pacific, Mountain, West South…"
#>  [7] "$ state.area     <dbl> 51609, 589757, 113909, 53104, 158693, 104247, 500…"
#>  [8] "$ center.x       <dbl> -86.7509, -127.2500, -111.6250, -92.2992, -119.77…"
#>  [9] "$ center.y       <dbl> 32.5901, 49.2500, 34.2192, 34.7336, 36.5341, 38.6…"
#> [10] "$ Population     <dbl> 3615, 365, 2212, 2110, 21198, 2541, 3100, 579, 82…"
#> [11] "$ Income         <dbl> 3624, 6315, 4530, 3378, 5114, 4884, 5348, 4809, 4…"
#> [12] "$ Illiteracy     <dbl> 2.1, 1.5, 1.8, 1.9, 1.1, 0.7, 1.1, 0.9, 1.3, 2.0,…"
#> [13] "$ Life.Exp       <dbl> 69.05, 69.31, 70.55, 70.66, 71.71, 72.06, 72.48, …"
#> [14] "$ Murder         <dbl> 15.1, 11.3, 7.8, 10.1, 10.3, 6.8, 3.1, 6.2, 10.7,…"
#> [15] "$ HS.Grad        <dbl> 41.3, 66.7, 58.1, 39.9, 62.6, 63.9, 56.0, 54.6, 5…"
#> [16] "$ Frost          <dbl> 20, 152, 15, 65, 20, 166, 139, 103, 11, 60, 0, 12…"
#> [17] "$ Area           <dbl> 50708, 566432, 113417, 51945, 156361, 103766, 486…"

read_glimpse(states_lines)
#> # A tibble: 3 x 15
#>   state.name state.abb state.region state.division state.area center.x
#> * <fct>      <fct>     <fct>        <fct>               <dbl>    <dbl>
#> 1 Alabama    AL        South        East South Ce…      51609    -86.8
#> 2 Alaska     AK        West         Pacific            589757   -127. 
#> 3 Arizona    AZ        West         Mountain           113909   -112. 
#> # … with 9 more variables: center.y <dbl>, Population <dbl>, Income <dbl>,
#> #   Illiteracy <dbl>, Life.Exp <dbl>, Murder <dbl>, HS.Grad <dbl>,
#> #   Frost <dbl>, Area <dbl>
```

## Generate pretty code to reproduce a data frame

The reading functions make it easy to get a question’s data into R, but
to construct a reproducible response requires the data in code form.
`dput` will produce runnable code, but the result is not very readable.
`write.so` and its alias `write_so` take a data frame and restructure
the results of `dput` to make it an ordinary `data.frame`, `data_frame`,
`tibble`, or `data.table` call, and when a name is detected, reassemble
assignment to that variable. The call is printed to the console and by
default copied to the clipboard. A language object version of the call
is returned,
invisibly.

``` r
options(read.so.write_clip = FALSE)    # don't write to clipboard by default

write.so(head(swiss))
#> swiss <- data.frame(
#>     Fertility = c(80.2, 83.1, 92.5, 85.8, 76.9, 76.1),
#>     Agriculture = c(17, 45.1, 39.7, 36.5, 43.5, 35.3),
#>     Examination = c(15L, 6L, 5L, 12L, 17L, 9L),
#>     Education = c(12L, 9L, 5L, 7L, 15L, 7L),
#>     Catholic = c(9.96, 84.84, 93.4, 33.77, 5.16, 90.57),
#>     Infant.Mortality = c(22.2, 22.2, 20.2, 20.3, 20.6, 26.6)
#> )

write_so(head(tibble::as_tibble(swiss)), indent = 2)
#> swiss <- data_frame(
#>   Fertility = c(80.2, 83.1, 92.5, 85.8, 76.9, 76.1),
#>   Agriculture = c(17, 45.1, 39.7, 36.5, 43.5, 35.3),
#>   Examination = c(15L, 6L, 5L, 12L, 17L, 9L),
#>   Education = c(12L, 9L, 5L, 7L, 15L, 7L),
#>   Catholic = c(9.96, 84.84, 93.4, 33.77, 5.16, 90.57),
#>   Infant.Mortality = c(22.2, 22.2, 20.2, 20.3, 20.6, 26.6)
#> )
```

## Related packages

  - [reprex](http://reprex.tidyverse.org/): A great way to generate
    reproducible examples. read.so is \[mostly\] for when people don’t
    use reprex. You should use reprex.
  - [datapasta](https://github.com/MilesMcBain/datapasta): A broader
    approach to getting data from the clipboard into R code containing
    alternatives to `write.so`. If you like `tibble::tribble`, you’ll
    like this package.
