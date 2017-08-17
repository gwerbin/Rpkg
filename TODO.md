- Tests (unit tests, maybe CLI tests with `expect`)
- Various TODOs in code
- Support non-CRAN repos (e.g. MRAN), Bioconductor,
  `devtools::install_github()`, local install, etc.
- Self-installer, e.g. for if/when I end up pulling in dependencies like
  `devtools` and `optparse`
- Platform-independent option handling
- Decide how to make this easy to run and install if there's an `optparse`
  dependency (self-install script? Makefile?)
- Man page
- Proper documentation
- Proper `help` output -- can `optparse` do this? - 
- Scour R documentation for hidden features and issues to be aware of
- Figure out what older versions of R can run this
- Consider using `devtools::install_*` family of functions for all 
  installation stuff
