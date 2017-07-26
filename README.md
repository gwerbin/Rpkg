# R CLI package manager

## Installation

1. Install R (version >3.4 highly recommended)
2. `ln -s ./rpkg.R ~/bin/Rpkg` or something along those lines

## Instructions

```
Commands:
    help
    install / add
    upgrade / update
    uninstall / remove
    search (not implemented)

Options:
    -V / --version
    -h / --help
```

# Example

```
$ Rpkg install purrr

Installing package into ‘/usr/local/lib/R/3.4/site-library’
(as ‘lib’ is unspecified)
trying URL 'https://cloud.r-project.org/src/contrib/purrr_0.2.2.2.tar.gz'
Content type 'application/x-gzip' length 70245 bytes (68 KB)
==================================================
downloaded 68 KB

* installing *source* package ‘purrr’ ...
** package ‘purrr’ successfully unpacked and MD5 sums checked
** libs
** R
** preparing package for lazy loading
** help
*** installing help indices
** building package indices
** testing if installed package can be loaded
* DONE (purrr)

The downloaded source packages are in
	‘/private/var/folders/4j/n8nxnsy12y92t475g318yptm0000gn/T/RtmpwUhQpG/downloaded_packages’
```
