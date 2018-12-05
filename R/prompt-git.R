
#' An example 'git' prompt
#'
#' It shows the current branch, whether there are
#' commits to push or pull to the default remote,
#' and whether the working directory is dirty.
#'
#' @param ... Unused.
#'
#' @family example prompts
#' @export
#' @examples
#' \dontrun{
#'   set_prompt(prompt_git)
#' }

prompt_git <- function(...) {

  if (!is_git_dir()) return ("> ")

  paste0(
    git_branch(),
    git_dirty(),
    git_arrows(),
    " > "
  )
}

is_git_dir <- function() {
  status <- git("status")
  attr(status, "status") == 0
}

## It fails before the first commit, so we just return "master" there

#' @export
#' @rdname prompt_git

git_branch <- function() {
  status <- git("rev-parse --abbrev-ref HEAD")
  if (attr(status, "status") != 0) "master" else status
}

#' @importFrom clisymbols symbol
#' @export
#' @rdname prompt_git

git_arrows <- function() {
  res <- ""

  status <- git("rev-parse --abbrev-ref @'{u}'")
  if (attr(status, "status") != 0) return(res)

  status <- git("rev-list --left-right --count HEAD...@'{u}'")
  if (attr(status, "status") != 0) return (res)
  lr <- scan(text = status, quiet = TRUE)
  if (lr[2] != 0) res <- paste0(res, symbol$arrow_down)
  if (lr[1] != 0) res <- paste0(res, symbol$arrow_up)

  if (res != "") paste0(" ", res) else res
}


#' @export
#' @rdname prompt_git

git_dirty <- function() {
  status <- git("diff --no-ext-diff --quiet --exit-code")
  if (attr(status, "status") != 0) "*" else ""
}

git <- function(args, quiet = TRUE, path = ".") {
  full <- paste0(shQuote(check_git_path()), " ", paste(args, collapse = ""))
  if (!quiet) {
    message(full)
  }

  result <- tryCatch(
    suppressWarnings(
      in_dir(path, system(full, intern = TRUE, ignore.stderr = quiet))
    ),
    error = function(x) x
  )

  if (methods::is(result, "error")) {
    result <- structure("", status = 1)
  } else {
    attr(result, "status") <- attr(result, "status") %||% 0
  }

  result
}

git_path <- function(git_binary_name = NULL) {
  # Use user supplied path
  if (!is.null(git_binary_name)) {
    if (!file.exists(git_binary_name)) {
      stop("Path ", git_binary_name, " does not exist", .call = FALSE)
    }
    return(git_binary_name)
  }

  # Look on path
  git_path <- Sys.which("git")[[1]]
  if (git_path != "") return(git_path)

  # On Windows, look in common locations
  if (os_type() == "windows") {
    look_in <- c(
      "C:/Program Files/Git/bin/git.exe",
      "C:/Program Files (x86)/Git/bin/git.exe"
    )
    found <- file.exists(look_in)
    if (any(found)) return(look_in[found][1])
  }

  NULL
}

check_git_path <- function(git_binary_name = NULL) {

  path <- git_path(git_binary_name)

  if (is.null(path)) {
    stop("Git does not seem to be installed on your system.", call. = FALSE)
  }

  path
}
