# Rpkg: command-line interface to the R package manager

<!-- TOC START -->
- [What is this?](#what-is-this)
  * [Show-off example](#show-off-example)
- [Installation](#installation)
- [Usage](#usage)
  * [Examples](#examples)
<!-- TOC END -->


## What is this?

`Rpkg` is a simple command-line interface to the R package manager.

Typically, R user install packages in the console, using functions like
`install.packages()`. I wrote this tool because I find it inconvenient to open
an R console to manage the R package library. It is especially useful for
scripting, which in turn can make it easier to encapsulate and reproduce your
development or research environment.

The vision for `Rpkg` is twofold:
1. Create a simple, unified interface to the package management features that
   are built into R.
2. Reach a stable, complete 1.0 interface that will not need to change much. In
   10 years, when GitHub has gone the way of SourceForge, you should be able to
   download and run this program without serious problems, as long as R itself
   does not undergo radical changes (which it historically has not).

If you have any suggestions, requests, or bugs to report, please feel free to
file an issue for them. You are also welcome to submit a pull request directly.
If you would like to contribute but don't know where to start, see the file
`TODO.md` some of the feature roadmap, or the various "TODO" comments in the
code.

### Show-off example

```
$ Rpkg install forecast

Installing package into ‘/usr/local/lib/R/3.4/site-library’
(as ‘lib’ is unspecified)
trying URL 'https://cloud.r-project.org/src/contrib/forecast_8.1.tar.gz'
Content type 'application/x-gzip' length 783567 bytes (765 KB)
==================================================
downloaded 765 KB

* installing *source* package ‘forecast’ ...
** package ‘forecast’ successfully unpacked and MD5 sums checked
** libs
** R
** data
*** moving datasets to lazyload DB
** inst
** byte-compile and prepare package for lazy loading
** help
*** installing help indices
*** copying figures
** building package indices
** installing vignettes
** testing if installed package can be loaded
* DONE (forecast)

The downloaded source packages are in
	‘/private/var/folders/4j/n8nxnsy12y92t475g318yptm0000gn/T/RtmpKRM4Ne/downloaded_packages’
```


## Installation

1. `git clone` this repo or download and extract a tagged release.
2. `make` or `make setup`
3. `make install`, using `sudo` if necessary for your system. By default this
   installs to `/usr/local/bin/Rpkg`, but you can change that location with the
   `RPKG_INSTALL_PREFIX` environment variable.

Uninstall with `make uninstall`.

Note that installation requires a symlink tothis repo, because the Library path
is found dynamically. Future releases will use Cmake (or a similar tool) to
configure and encode the correct paths so thatRpkg can be copied, not linked.

I've personally tested the Makefile on the MacOS version of GNU Make (version
3.81) and vanilla GNU Make 4.2.1. Your mileage might vary with BSD Make or
other/ancient Makes.

I've also only personally tested this on R version 3.4. I don't *think* I'm
using anything specific to recent R versions, but if anything breaks in old
versions, please file an issue.

This script is intended to be run by `Rscript --no-save`. Note that `Rscript`
already implies `--slave` and `--no-restore`. It _does_ source your init file,
i.e. `Rprofile`. This is to ensure that any user configuration like
`options(repos = c(CRAN = "https://cloud.r-project.org"))` is respected.
HOWEVER, Rpkg is **not** robust to excessive tinkering, and if something breaks
try running `Rscript --no-save --no-init cli/Rpkg` before reporting a bug.

The default CRAN repository when using this tool is
`"https://cloud.r-project.org"`. The option to use a non-CRAN repository will
become available after proper command-line parsing has been implemented.


## Usage

Using Rpkg is much like any other package manager: `yum`, `brew`, `pip`, `npm`,
etc. Commands take the form:

```shell
Rpkg <main_options> <subcommand> <subcommand_options> <arguments>
```

The `main_options` are Unix-style flags (even on Windows, they are currently
hardcoded to use dashes and not slashes) that change the behavior of the main
`Rpkg` command. The `subcommand_options` apply specifically to the subcommand
being called.

The `Rpkg help` subcommand prints a list of available commands and options for 
the `Rpkg` script itself. In the future, `Rpkg help <subcommand>` will print 
similar information for the listed subcommand.

As a reference, the `Rpkg help` string from the source code is copied below:

```
Rpkg version %s

Commands:
    help [ SUBCOMMAND ]
        Get help for SUBCOMMAND.

    ( install | add ) PKG_NAME [ PKG_NAME ... ]
        Install packages. See R help for install.packages().

    ( uninstall | remove ) PKG_NAME [ PKG_NAME ... ]
        Uninstall packages. See R help for remove.packages().

    ( update | upgrade ) ( --all | [ PKG_NAME [ PKG_NAME ... ] ] )
        Update packages. See R help for update.packages(). PKG_NAME is required 
        if --all is not specified.

    reinstall PKG_NAME [ PKG_NAME ... ]
      Remove then reinstall packages.

    outdated
      Print a list of outdated packages.

    list
      Print a list of installed packages.

    info PKG_NAME [ PKG_NAME ... ]
      Print package info from the repository.

    search ( STRING | /REGEX/ )
      Search for a package name in the repository. Regex is PCRE, and is 
      case-sensitive only if it contains an upper-case character.

Options:
    Long options that accept arguments can be specified with
        --option=ARG
    or
        --option ARG
    interchangeably.

    -V
    --version      Print version info and exit.

    -h
    --help         Print this help and exit.

    -v
    --verbose       options(\"verbose\") <- TRUE

    --type=TYPE     options(\"pkgType\") <- $TYPE

    -j NJOBS
    --jobs=[NJOBS]
    --ncpu=[NJOBS]  options(\"Ncpu\") <- $NJOBS
```


### Examples

Install `caret` and `shiny` from CRAN:

```shell
Rpkg add caret shiny
```

Update `caret` and `shiny` to latest version on CRAN:

```shell
Rpkg update caret shiny
```

Update all packages:

```shell
Rpkg update --all
```

Uninstall `caret` and `shiny`:

```shell
Rpkg remove caret shiny
```

Check for outdated packages, get info about the `forestFloor` package, list 
installed packages:

```shell
Rpkg outdated
Rpkg info forestFloor
Rpkg list
```

Search CRAN:

```shell
Rpkg search ggplot
Rpkg search '/^z[^aeiou]/' # pattern is a regular expression if wrapped in slashes
Rpkg search '/^GG/'        # case-sensitive only if the pattern has an upper case character
```


[modeline]: # ( vim: set fenc=utf-8 nospell ft=pandoc tw=80 et sw=4: )
