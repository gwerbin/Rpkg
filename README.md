# Rpkg: command-line interface to the R package manager

## What is this?

This is a very simple command-line interface to the R package manager. 
Typically this system is accessed using functions in the R console like 
`install.packages()`. I wrote this tool because sometimes I find it 
inconvenient to open an R console to manage the R package library.

The interface is currently very minimal, and several features have not yet 
been implemented. On the other hand, it has no dependencies other than R 
itself. The vision is twofold:
1. Create a simple, unified interface to the package management features 
   that are built into R.
2. Reach a stable, complete 1.0 interface that will not need to change much. 
   In 10 years, when GitHub has gone the way of SourceForge, you should be 
   able do download and run this program without serious problems, as long as 
   R itself does not undergo radical changes (which it historically has not).

If you like this program, or please feel free to submit pull requests or post 
issues with bugs reports, feature requests, etc. I can't guarantee that I'll 
have much time to work on it, but I do use it myself on a regular basis. So if 
there is a substantial improvement to be made or a serious bug to fix, I 
will be motivated to integrate the changes. See `TODO.md` for some of the 
roadmap, as well as the various `TODO`s in the source code itself.

### Show-off example

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


## Installation instructions

1. Install R version > 3.4 (older versions are untested and unsupported)
2. `sudo ln -s ./rpkg.R /usr/local/bin/Rpkg`, or otherwise make the `rpkg.R` 
   script visible in your system's `PATH` variable.

In the code and documentation, I assume that you have copied or linked 
`rpkg.R` with the name `Rpkg`, and that it is user-executable. Any other usage 
is untested and unsupported.

This script is intended to be run by `Rscript --no-save --no-restore`. It 
_does_ source your init file, i.e. `Rprofile`. This is to ensure that any user 
configuration like `options(repos = c(CRAN = "https://cloud.r-project.org"))` 
is respected. HOWEVER, Rpkg is **not** robust to excessive tinkering, and if 
something breaks try `Rscript --no-save --no-restore --no-init rpkg.R` before 
reporting a bug.


## Usage instructions

Using Rpkg is much like any other package manager: `yum`, `brew`, `pip`, 
`npm`, etc. Commands take the form:

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
Commands:
    help                      [ subcommand ]
      NOTE: not fully implemented
    ( install | add )         pkg_name ...
    ( uninstall | remove )    pkg_name ...
    ( update | upgrade )      [ --all ] pkg_name ...
    outdated
    list
    info                      pkg_name ...
    search                    ( string | /regex/ )
      NOTE: regex is PCRE, case-sensitive only if uppercase character is detected

Options:
    -V / --version
    -h / --help
```


### Examples

Install `caret` and `shiny` from CRAN:

```shell
Rpkg install caret shiny
Rpkg add caret shiny
```

Update `caret` and `shiny` to latest version on CRAN:

```shell
Rpkg update caret shiny
Rpkg upgrade caret shiny
```

Update all packages:

```shell
Rpkg upgrade --all
Rpkg update --all
```

Uninstall `caret` and `shiny`:

```shell
Rpkg uninstall caret shiny
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
