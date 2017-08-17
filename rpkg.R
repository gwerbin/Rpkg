#! Rscript --no-save --no-restore

# TODO: main() CLI argument handling
#       use optparse() library?
# TODO: unified interface instead of hideous error-prone copy and paste?
#       specifically, needs a unified abstraction for checking whether a pkg 
#       has already been installed


..VERSION.. <- "0.2.1"


cat0 <- function (...) {
  cat(..., sep = "")
}


cat0n <- function(...) {
  cat0(..., "\n")
}


exit <- function(status = 0L, msg = NULL, con = if (status) stderr() else stdout()) {
  if (!is.null(msg)) {
    cat0n(msg, file = con)
  }
  quit(save = "no", status = status, runLast = FALSE)
}


#' Get names of installed packags
#'
#' @param ... Arguments passed to \code{\link[utils]{installed.packages()}}
#' @return Character vector of installed package names
get_installed_package_names <- function(...) {
  rownames(utils::installed.packages(...))
}


#' Install packages
#'
#' @param packages Character vector of package names
#' @param opts List of named options, passed to \code{\link[utils]{install.packages()}}
#' @return Result of \code{\link[utils]{install.packages}}
pkg_install <- function(packages, opts = list()) {
  installed <- get_installed_package_names()
  already_installed <- intersect(packages, installed)

  if (length(already_installed)) {
    message("These packages are already installed and will be skipped:")
    cat(already_installed, "\n", file = stderr())
    packages_to_install <- setdiff(packages, already_installed)
  } else {
    packages_to_install <- packages
  }

  if (!length(packages_to_install)) {
    exit(66, "No packages specified")
  }
  do.call(utils::install.packages, c(list(packages_to_install), opts))
}


#' Remove packages
#'
#' @param packages Character vector of package names
#' @param opts List of named options, passed to \code{\link[utils]{remove.packages()}}
#' @return Result of \code{\link[utils]{remove.packages()}}
pkg_remove <- function(packages, opts = list()) {
  installed <- get_installed_package_names()
  notyet_installed <- setdiff(packages, installed)

  if (length(notyet_installed)) {
    message("These packages are not installed and will be skipped:")
    cat(notyet_installed, "\n", file = stderr())
    packages_to_remove <- intersect(packages, installed)
  } else {
    packages_to_remove <- packages
  }

  if (!length(packages_to_remove)) {
    exit(66, "No packages specified")
  }
  do.call(utils::remove.packages, c(list(packages_to_remove), opts))
}


#' Update packages
#'
#' @param packages Character vector of package names
#' @param opts List of named options, passed to \code{\link[utils]{update.packages()}}
#' @return Result of \code{\link[utils]{update.packages()}}
pkg_update <- function(packages, opts = list()) {
  installed <- get_installed_package_names()
  notyet_installed <- setdiff(packages, installed)

  if (length(notyet_installed)) {
    message("These packages are not installed and will be skipped:")
    cat(notyet_installed, "\n", file = stderr())
    packages_to_update <- intersect(packages, installed)
  } else {
    packages_to_update <- packages
  }

  if (!length(packages_to_update)) {
    exit(66, "No packages specified")
  }
  opts$ask <- FALSE
  opts$oldPkgs <- NULL
  do.call(utils::update.packages, c(list(oldPkgs = packages_to_update), opts))
}


#' Check for outdated packages
#'
#' @param packages Character vector of package names
#' @param opts List of named options, passed to \code{\link{old.packages()}}
#' @return Result of \code{\link[utils]{old.packages()}}
pkg_outdated <- function(packages, opts = list()) {
  if (length(packages)) {
    exit(69, "Package selection not implemented for this subcommand")
  }

  out <- do.call(utils::old.packages, opts)[, c("Installed", "ReposVer")]
  colnames(out) <- c("Local", "Repo")
  out
}

pkg_list <- function(packages, opts = list()) {
  cat(get_installed_package_names(), sep = "\n")
}

pkg_info <- function(packages, opts = list()) {
  exit(69, "Package info not implemented")
}

pkg_search <- function(packages, opts = list()) {
  exit(69, "Package search not implemented")
}


rpkg_version <- ..VERSION..
rpkg_help <- sprintf(
"Rpkg version %s

Commands:
    help
    install / add
    update / upgrade
    outdated
    uninstall / remove
    list
    info (not implemented)
    search (not implemented)

Options:
    -V / --version
    -h / --help",
rpkg_version)


main <- function() {
  cli_args <- commandArgs(trailingOnly = TRUE)

  cmd <- cli_args[1]
  pkgs <- cli_args[-1]

  if (any(cli_args %in% c("-V", "--version"))) {
    exit(0, rpkg_version)
  }

  if (any(cli_args %in% c("-h", "--help"))) {
    exit(0, rpkg_help)
  }

  opts <- list()

  # TODO: handle arguments platform-independently
  # TODO: handle "--" to stop processing option flags?
  # TODO: handle "ask = TRUE" (why doesn't it work, anyway?)
  # TODO: handle verbosity
  # TODO: self-update?
  switch(cmd,
    "install"   = pkg_install(pkgs, opts),
    "add"       = pkg_install(pkgs, opts),

    # TODO: handle "--all"
    "update"    = pkg_update(pkgs, opts),
    "upgrade"   = pkg_update(pkgs, opts),

    # TODO: handle pkg names
    "outdated"  = pkg_outdated(NULL, opts),

    "remove"    = pkg_remove(pkgs, opts),
    "uninstall" = pkg_remove(pkgs, opts),

    "list"      = pkg_list(pkgs, opts),
    "info"      = pkg_info(pkgs, opts),
    "search"    = pkg_search(pkgs, opts),

    "help"      = exit(0, rpkg_help),
    # TODO: `help` accepts arguments and prints help info about each subcommand
    `NA`        = exit(64, "No command specified. Try `Rpkg help` for instructions."),
                  exit(64, sprintf("Invalid command: %s", cmd))
  )
}


main()
