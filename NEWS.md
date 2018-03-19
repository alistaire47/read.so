# read.so 0.0.1.9000

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
