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
- Other packages to explore:
    - https://cran.r-project.org/package=rbundler (apparently dead, would need to be forked)
    - https://cran.r-project.org/package=rversions (r version string parser)
    - https://cran.r-project.org/package=seer (cran search)
    - https://cran.r-project.org/package=crayon (colored output)
    - https://cran.r-project.org/package=docopt (alt. to `optparse`)
    - https://cran.r-project.org/package=remotes (lightweight reimpl. of 
      `install_*` from `devtools`)
    - https://cran.r-project.org/package=automagic (install packages parsed 
      from R code)
    - https://cran.r-project.org/package=pacman (did I reinvent the wheel?)
    - https://cran.r-project.org/package=install.load (gracefully check for 
      installed packages)
    - https://cran.r-project.org/package=desc (manipulate DESCRIPTION files)
    - https://cran.r-project.org/package=cranlike (CRAN-like repo tools)
    - https://cran.r-project.org/package=mockery (mocking/stubbing framework)
    - https://cran.r-project.org/package=debugme (R debugging utils)
    - https://cran.r-project.org/package=subprocess (manage subprocesses for 
      R; good for parallel installs?)
    - https://cran.r-project.org/package=secret (API keys and such; maybe good 
      for working w/ private package repos)
    - https://cran.r-project.org/package=yearn (install and load packages from 
      various locations)
    - https://cran.r-project.org/package=sessioninfo (replacement for 
      `utils::sessionInfo()`)
