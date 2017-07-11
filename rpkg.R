#! Rscript --no-save --no-restore

# TODO: main() CLI argument handling


get_installed_packages <- function(options = list()) {
  rownames(do.call(utils::installed.packages, options))
}


install <- function(packages, options = list()) {
  # TODO: say something when a package is already installed,
  #       instead of failing silently
  installed <- get_installed_packages()
  packages_to_install <- setdiff(packages, installed)

  do.call(utils::install.packages, c(list(packages_to_install), options))
}


# uninstall <- function(packages, options = list()) {
# }


# upgrade <- function(packages, options = list() {
# }


# search <- function(packages, options = list()) {
# }


main <- function() {
  all_args <- commandArgs(trailingOnly = TRUE)

  cmd <- all_args[1]

  # TODO
  args <- all_args[-1]
  options <- list()

  switch(cmd,
    "install" = install(args, options),
    stop(sprintf("Invalid command: %s", cmd))
  )
}

main()
