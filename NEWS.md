# read.so 0.1.1

* Fixes `read.str` and `read_glimpse` for changes in print methods.
* Removes explicit support for `tibble::data_frame` as it is now deprecated in 
  favor of `tibble::tibble`

# read.so 0.1.0

* Adds `write.so` and `write_so`, which output clean code and calls to 
  reproduce and assign a data frame.
* `read_glimpse` handles the new behavior of `glimpse` with single character 
  ellipses.
* `read_glimpse` handles commas and quotes in quoted strings and factors 
  properly.
* `read.str` and `read_str` now read single-string input properly.

# read.so 0.0.1

* Changed default of `read_so`'s `row_names` parameter to guess based on header 
  and first row.
* Added `na.strings`/`na` parameters to `read.so`/`read_so` with a default that 
  will catch data.frame's character `<NA>` printing.
* Added a `NEWS.md` file to track changes to the package.
* Added `read.str`/`read_str` and `read.glance`/`read_glance` to read the print 
  methods of `str.data.frame` and `tibble::glance`, respectively.
  
# read.so 0.0.0.9000
  
* Added `read.so` and `read_so` to read data.frame and tibble print methods.
* Added `read.md` and `read_md` to read Markdown tables.
