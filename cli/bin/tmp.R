#! Rscript --no-save

get_filename_arg <- function() {
  cli_args <- commandArgs()
  matches <- regexec("^--file=(.+)$", cli_args)

  out <- mapply(function(s, m) {
    if (any(m > 0)) {
      substr(s, m[2], m[2] + attr(m, "match.length")[2])
    } else {
      NA
    }
  }, cli_args, matches)

  out <- out[!is.na(out)]
  if (!length(out)) {
    stop("No '--file=<filename>' option found. Make sure you are using Rscript and not R itself.", call. = FALSE)
  }
  out
}

script_filename <- get_filename_arg()
script_filename <- normalizePath(script_filename, mustWork = TRUE)
script_dir <- dirname(dirname(script_filename))

#source(file.path(script_dir, "library", "Rpkg", "R", "rpkg.R"))

library_dir <- file.path(script_dir, "library")
.libPaths(library_dir)

library("Rpkg")



