## code to prepare `comments` dataset goes here

comments <- readr::read_delim("inst/extdata/comments.csv")

usethis::use_data(comments, overwrite = TRUE)
