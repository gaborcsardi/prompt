
# prompt

> Dynamic R Prompt

<!-- badges: start -->
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![R-CMD-check](https://github.com/gaborcsardi/prompt/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/gaborcsardi/prompt/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/gaborcsardi/prompt/branch/main/graph/badge.svg)](https://app.codecov.io/gh/gaborcsardi/prompt?branch=main)
<!-- badges: end -->

Set the R prompt dynamically, from a function. The package contains some
examples.

## Examples

![](https://user-images.githubusercontent.com/660288/109492379-3305e800-7a8b-11eb-9311-8196b6383d9e.png)

This is `prompt_fancy()` and it has
* The status of the last command (success or failure).
* The amount of memory allocated by the current R process.
* The name of the R package being developed using
  [devtools](https://github.com/r-lib/devtools).
* Name of the active git branch.
* State of the git working tree (needs pushes, pulls, and/or dirty).

![](https://user-images.githubusercontent.com/660288/109492387-36996f00-7a8b-11eb-8d0e-a43eea797da2.png)

A [powerline](https://github.com/powerline/powerline) clone, that also
shows the system load average and the current working directory.

## Installation

Install the package from CRAN, as usual:

```r
install.packages("prompt")
```

## Usage

Use one of the pre-defined prompts, as on the screenshots, or create your own.
You can set the prompt in your `.Rprofile`. Maybe you only want to do this
in interactive mode:

```r
if (interactive()) prompt::set_prompt(prompt::prompt_fancy)
```

or the powerline prompt:

```r
if (interactive()) prompt::set_prompt(prompt::new_prompt_powerline())
```

## License

MIT © Gábor Csárdi
