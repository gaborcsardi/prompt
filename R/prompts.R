
prompt_runtime_factory <- function() {

  last <- proc.time()
  last[] <- NA_real_

  function(...) {
    diff <- proc.time() - last
    elapsed <- sum(diff) - diff["elapsed"]
    last <<- proc.time()
    if (!is.na(elapsed) && elapsed > 1) {
      paste0(round(elapsed), "s > ")
    } else {
      "> "
    }
  }
}

#' A prompt that shows the CPU time used by the last top level expression
#'
#' @param ... Arguments, ignored.
#'
#' @family example prompts
#' @export

prompt_runtime <- prompt_runtime_factory()

#' A prompt that shows the status (OK or error) of the last expression
#'
#' @param expr Evaluated expression.
#' @param value Its value.
#' @param ok Whether the evaluation succeeded.
#' @param visible Whether the result is visible.
#'
#' @importFrom clisymbols symbol
#' @family example prompts
#' @export

prompt_error <- function(expr, value, ok, visible) {
  if (ok) {
    paste0(symbol$tick, " ", symbol$pointer, " ")
  } else {
    paste0(symbol$cross, " ", symbol$pointer, " ")
  }
}

prompt_error_hook <- function() {
  update_prompt(expr = NA, value = NA, ok = FALSE, visible = NA)

  orig <- prompt_env$error
  if (!is.null(orig) && is.function(orig)) orig()
}


prompt_memuse_factory <- function() {
  size <- 0
  unit <- "MiB"

  function(...) {
    current <- memuse::Sys.procmem()[[1]]
    size <<- memuse::mu.size(current)
    unit <<- memuse::mu.unit(current)

    paste0(round(size, 1), " ", unit, " ", symbol$pointer, " ")
  }
}

#' Example prompt that shows the current memory usage of the R process
#'
#' @param ... Ignored.
#'
#' @family example prompts
#' @export

prompt_memuse <- prompt_memuse_factory()
