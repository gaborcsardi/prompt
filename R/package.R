
#' Dynamic R Prompt
#'
#' Set the R prompt dynamically, from a function.
#'
#' @docType package
#' @name prompt
NULL

prompt_env <- new.env(parent = emptyenv())
prompt_env$prompt <- "> "
prompt_env$task_id <- NA
prompt_env$default_prompt <- prompt_env$prompt
prompt_env$disabled_prompt <- NULL
prompt_env$in_use <- TRUE
prompt_env$colors <- new.env(parent = emptyenv())

update_callback <- function(expr, value, ok, visible) {
  try(suppressWarnings(update_prompt(expr, value, ok, visible)))
  TRUE
}

update_prompt <- function(...) {
  mine <- prompt_env$prompt
  if (is.function(mine)) mine <- mine(...)
  if (is.string(mine)) options(prompt = mine)
}

#' Set and control the prompt
#'
#' @param value A character string for a static prompt, or
#'   a function that is called after the evaluation every expression
#'   typed at the R prompt. The function should always return a
#'   character scalar.
#' @return No return value, called for side effects.
#'
#' @details
#' Function \code{update_prompt()} is used to replace the default \R
#' prompt with a custom prompt.   A custom prompt can be disabled
#' with \code{suspend()} and then re-enable with \code{restore()}.
#' Function \code{toggle()} toggles between the two.
#'
#' @export

set_prompt <- function(value) {
  stopifnot(is.function(value) || is.string(value))
  assign("prompt", value, envir = prompt_env)
  if (is.na(prompt_env$task_id)) {
    assign("task_id", addTaskCallback(update_callback), envir = prompt_env)
    if (getRversion() >= "4.0" && Sys.getenv("PROMPT_NO_GLOBAL") != "true") {
      globalCallingHandlers(                                     # nocov
        error = function(err) update_callback(NA, NA, FALSE, NA) # nocov
      )
    }
  }  
  update_prompt(NULL, NULL, TRUE, FALSE)

  invisible()
}

if (getRversion() < "4.0") globalVariables("globalCallingHandlers")

#' @rdname set_prompt
#' @export

suspend <- function() {
  if (!prompt_env$in_use) return(invisible(FALSE))
  prompt_env$disabled_prompt <- prompt_env$prompt
  set_prompt(prompt_env$default_prompt)
  prompt_env$in_use <- FALSE
  invisible(TRUE)
}

#' @rdname set_prompt
#' @export

restore <- function() {
  if (prompt_env$in_use) return(invisible(FALSE))
  set_prompt(prompt_env$disabled_prompt)
  prompt_env$in_use <- TRUE
  invisible(TRUE)
}

#' @rdname set_prompt
#' @export

toggle <- function() {
  if (prompt_env$in_use) suspend() else restore()
}
