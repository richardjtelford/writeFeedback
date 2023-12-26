#' Feedback
#' @description
#' `feedback()` opens a shiny gadget which complies selected feedback from a
#' file or data.frame, with the opportunity to write bespoke text.
#' When the feedback is complete, clip the copy button to copy the text,
#' and then the reset button.
#'
#' @param com Path to comment file or data.frame of comments
#' @param ... Arguments to `readr::read_delim()` if `com` if the path to a file.
#'
#' @details the file (or data.frame) `com` needs to have four columns.
#' - topic: collective name for group of comments. Need to be in the expected order.
#' - choiceNames: short name displayed with the checkbox
#' - choiceValues: text that is added to the feedback
#' - selected: boolean specifying whether comment should be included by default.
#'
#'
#' @examples
#' # feedback(comments)
#'
#' # path to example file with feedback
#' fs::path_package("writeFeedback", "extdata/comments.csv")
#'
#' @importFrom rclipboard rclipboardSetup rclipButton
#' @importFrom purrr map map_chr
#' @importFrom dplyr group_by group_split mutate
#' @importFrom stringr str_replace_all
#' @importFrom rlang .data
#' @importFrom forcats as_factor
#' @import shiny
#' @export


feedback <- function(com, ...) {
  if (is.character(com)) {
     # load file
    com <- readr::read_delim(com, ...)
  }

  ui <- fluidPage(
    rclipboardSetup(),
    sidebarLayout(
      sidebarPanel(
        uiOutput("poss_comments")
      ),
      mainPanel(
        htmlOutput("txt"),
        uiOutput("clip"),
        actionButton("reset_input", "Reset inputs")
      )
    )
  )

  server <- function(input, output, session) {

    com <- com |>
      mutate(topic = as_factor(.data$topic)) |>
      group_by(.data$topic) |>
      group_split()
    n <- length(com)

    # compile text
    txt <- reactive({
      x <- map(seq_len(n), \(i){
        c(
          input[[paste0("topic_", i)]],
          input[[paste0("extra_", i)]]
        )
        }) |>
        map_chr(\(x) paste(x, collapse = "<br>")) |>
        paste(collapse = "<br><br>")
      x}
      )

    # make text for display
    output$txt <- renderText(txt())

    # make UI
    output$poss_comments <- renderUI({
      input$reset_input
      ui <- 1:n |>
        map(
          \(i) {
            co <- com[[i]]
            list(
              checkboxGroupInput(
                inputId = paste0("topic_", i),
                label = co$topic[1],
                selected = co$choiceValues[co$selected],
                choiceNames = as.list(co$choiceNames),
                choiceValues = as.list(co$choiceValues)
              ),
              textInput(
                inputId = paste0("extra_", i),
                label = paste(co$topic[1], "extra"),
                placeholder = "Extra comments"
              )
            )

      })
      do.call("tagList", ui)
    })

    # copy output button
    output$clip <- renderUI({
      rclipButton(
        inputId = "clipbtn",
        label = "Copy",
        clipText = str_replace_all(txt(), "<br>", "\n"),
        icon = icon("clipboard"),
        tooltip = "Copy output",
        placement = "top",
        options = list(delay = list(show = 800, hide = 100), trigger = "hover")
      )
    })
  }

  runGadget(ui, server, viewer = dialogViewer(dialogName = "Write comments"))
}

