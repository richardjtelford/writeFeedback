
<!-- README.md is generated from README.Rmd. Please edit that file -->

# writeFeedback

<!-- badges: start -->
<!-- badges: end -->

Writing useful feedback on student assignments is a slow job. Many
issues occur repeatedly. Rather than writing the same comment
repeatedly, `writeFeedback` uses a shiny gadget to let you select
pre-written comments you want to include in the feedback, and add any
bespoke text.

## Installation

You can install the development version of `writeFeedback` from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("richardjtelford/writeFeedback")
```

## Example

The shiny gadget can be started with `feedback()`, which has a single
argument that either gives the path to a csv file (or similar), or
provides a data.frame.

The data.frame `comments` is provided as an example.

``` r
# load package
library(writeFeedback)
## launch shiny gadget with example comments
feedback(com = comments)
```

If provided, the data file must be readable and have the same column
names as the example `comments` data.frame. An example csv file is
included in the package. You can find it with

``` r
fs::path_package("writeFeedback", "extdata/comments.csv")
```
