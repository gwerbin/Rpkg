# TODO:
#   - move all side effects (i.e. "catn(...)") to CLI
#   - return S3 (?) classes/structures in this code
#   - define format() and/or print() methods for S3 classes
#   - move sysexits to its own package
#   - TODO: use optparse or getopt library and .libPaths() so user doesn't have to have pkgs installed
#     e.g.:
#         .libPaths('/usr/local/lib/rpkg/library')
#     and then can call getopt::getopt() or optparse::OptionParser as usual
#     NOTE: be careful with this because it could really swell installation size

VERSION <- "0.5.0-rc02"


#### Helpers ----


# man 3 sysexits
sysexits <- new.env()
sysexits$EX_OK          <- 0L
sysexits$EX_USAGE       <- 64
#sysexits$EX_DATAERR     <- 65
sysexits$EX_NOINPUT     <- 66
#sysexits$EX_NOUSER      <- 67
#sysexits$EX_NOHOST      <- 68
sysexits$EX_UNAVAILABLE <- 69
sysexits$EX_SOFTWARE    <- 70
#sysexits$EX_OSERR       <- 71
#sysexits$EX_OSFILE      <- 72
#sysexits$EX_CANTCREAT   <- 73
#sysexits$EX_IOERR       <- 74
#sysexits$EX_TEMPFAIL    <- 75
#sysexits$EX_PROTOCOL    <- 76
#sysexits$EX_NOPERM      <- 77
#sysexits$EX_CONFIG      <- 78


unattr <- function(x) {
  `attributes<-`(x, NULL)
}


`%!in%` <- function(x, table) {
  match(x, table, nomatch = 0L) == 0L
}


catn <- function(...) {
  cat(..., "\n")
}


cat0 <- function(...) {
  cat(..., sep = "")
}


cat0n <- function(...) {
  cat0(..., "\n")
}


exit <- function(status = 0L, msg = NULL, con = if (length(status) && is.numeric(status) && status) stderr() else stdout()) {
  if (!is.null(msg) && length(msg) > 0) {
    cat0n(unlist(msg), file = con)
  }
  quit(save = "no", status = status, runLast = FALSE)
}


text_search <- function(x, pattern, perl = TRUE, ignore.case = TRUE) {
  if (length(pattern) != 1 || !is.character(pattern)) {
    stop("Invalid pattern")
  }

  regex_match <- regexpr("^/(.*)/$", pattern, perl = TRUE)
  regex_start <- attr(regex_match, "capture.start")
  if (regex_start < 0) {
    # is not regex
    fixed <- TRUE
    perl <- FALSE
    ignore.case <- FALSE
    do_lowercase <- ignore.case
  } else {
    # is regex
    pattern <- substr(pattern, regex_start, regex_start + attr(regex_match, "capture.length") - 1)
    fixed <- FALSE
    perl <- TRUE
    do_lowercase <- FALSE
    ignore.case <- !grepl("[[:upper:]]", pattern)
  }

  ix <- grep(if (do_lowercase) tolower(pattern) else pattern, if (do_lowercase) tolower(x) else x,
             perl = perl, fixed = fixed, ignore.case = ignore.case)
  x[ix]
}


#' Get names of installed packags
#'
#' @param ... Arguments passed to \code{\link[utils]{installed.packages()}}
#' @return Character vector of installed package names
get_installed_package_names <- function(...) {
  rownames(utils::installed.packages(...))
}


#' Validate which packages are not currently installed
#'
#' @param packages Character vector of package names
#' @return Character vector of package names that are not yet installed
#' @note Side effect: prints a message and names of currently installed packages to Stderr
validate_notyet_installed <- function(packages) {
  all_installed <- get_installed_package_names()
  already_installed <- intersect(packages, all_installed)

  if (length(already_installed)) {
    message("These packages are already installed and will be skipped:")
    cat(already_installed, file = stderr(), sep = "\n")
    not_yet_installed <- setdiff(packages, already_installed)
  } else {
    not_yet_installed <- packages
  }

  not_yet_installed
}


#' Validate which packages are currently installed
#'
#' @param packages Character vector of package names
#' @return Character vector of package names that are already installed
#' @note Side effect: prints a message and names of not-yet installed packages to Stderr
validate_already_installed <- function(packages) {
  all_installed <- get_installed_package_names()
  not_yet_installed <- setdiff(packages, all_installed)

  if (length(not_yet_installed)) {
    message("These packages are not installed and will be skipped:")
    cat(not_yet_installed, file = stderr(), sep = "\n")
    already_installed <- intersect(packages, all_installed)
  } else {
    already_installed <- packages
  }

  already_installed
}


#### R package management ----


#' Install packages
#'
#' @param packages Character vector of package names
#' @param opts List of named options, passed to \code{\link[utils]{install.packages()}}
#' @return Result of \code{\link[utils]{install.packages}}
pkg_install <- function(packages, opts = list()) {
  packages_to_install <- validate_notyet_installed(packages)

  if (!length(packages_to_install)) {
    exit(sysexits$EX_NOINPUT, "No packages specified")
  }

  do.call(utils::install.packages, c(list(packages_to_install), opts))
}


#' Remove packages
#'
#' @param packages Character vector of package names
#' @param opts List of named options, passed to \code{\link[utils]{remove.packages()}}
#' @return Result of \code{\link[utils]{remove.packages()}}
pkg_remove <- function(packages, opts = list()) {
  packages_to_remove <- validate_already_installed(packages)

  if (!length(packages_to_remove)) {
    exit(sysexits$EX_NOINPUT, "No packages specified")
  }

  do.call(utils::remove.packages, c(list(packages_to_remove), opts))
}


#' Update packages
#'
#' @param packages Character vector of package names
#' @param opts List of named options, passed to \code{\link[utils]{update.packages()}}
#' @return Result of \code{\link[utils]{update.packages()}}
# TODO: warn if --all passed along with args
pkg_update <- function(packages, opts = list()) {
  if (length(packages) == 0 && "all" %in% names(opts) && opts$all) {
    catn("Updating all packages")
    opts$oldPkgs <- NULL
  } else {
    packages_to_update <- validate_already_installed(packages)

    if (!length(packages_to_update)) {
      exit(sysexits$EX_NOINPUT, "No packages specified")
    }

    opts$oldPkgs <- packages_to_update
  }

  opts$all <- NULL
  opts$ask <- FALSE
  do.call(utils::update.packages, opts)
}


#' Check for outdated packages
#'
#' @param packages Character vector of package names
#' @param opts List of named options, passed to \code{\link{old.packages()}}
#' @return Result of \code{\link[utils]{old.packages()}}
pkg_outdated <- function(packages, opts = list()) {
  if (length(packages)) {
    exit(sysexits$EX_UNAVAILABLE, "Package selection not implemented for this subcommand")
  }

  out <- do.call(utils::old.packages, opts)
  if (is.null(out)) {
    catn("All packages are up-to date")
  } else {
    out <- out[, c("Package", "Installed", "ReposVer")]
    colnames(out) <- c("Package", "Installed", "Remote")
    rownames(out) <- rep("", nrow(out))
    print(out, quote = FALSE)
  }
}


pkg_list <- function(packages, opts = list()) {
  cat(get_installed_package_names(), sep = "\n")
}


# TODO: fuzzy search with --fuzzy, ignore case with --ignore-case, regex search with --regex (instead of detecting '/pattern/')
pkg_info <- function(packages, opts = list()) {
  if (length(packages) < 0) {
    exit(sysexits$EX_NOINPUT, "No packages specified")
  }

  pkg_avail <- as.data.frame(available.packages())
  pkg_inst <- as.data.frame(installed.packages())
  pkgs <- merge(pkg_avail, pkg_inst, by = "Package", suffixes = c("", "_DELETEME"), all = TRUE)
  pkgs <- pkgs[, grep("_DELETEME", names(pkgs), invert = TRUE)]
  pkgs[["CRAN"]] <- paste0("https://cran.r-project.org/package=", pkgs[, "Package"])

  # TODO: parse and compare installed vs latest available in repo (e.g. version numbers)
  for (package in packages) {
    if (package %!in% pkgs$Package) {
      catn(sprintf("Unknown package: %s. Try: Rpkg search %s", package, package))
    } else {
      cat(sprintf("%s: %s", names(pkgs), as.character(pkgs[pkgs$Package == package,,drop = TRUE])), sep = "\n")
      cat("\n")
    }
  }
}


# Convenience alias for "uninstall" followed by "install"
pkg_reinstall <- function(packages, opts = list()) {
  for (package in packages) {
    pkg_remove(package)
    pkg_install(package, opts)
  }
}


pkg_search <- function(patterns, opts = list()) {
  if (length(patterns) < 0) {
    exit(sysexits$EX_NOINPUT, "No patterns specified")
  }

  avail <- available.packages()
  pkgs <- character(0)
  for (pattern in patterns) {
    pkgs <- c(pkgs, text_search(avail[,"Package"], pattern))
  }
  cat(sort(unique(pkgs)), sep = "\n")
}
