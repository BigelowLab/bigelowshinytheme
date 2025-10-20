#' Creates and returns a Bigelow-style theme object for R Shiny.
#' @export
#' @return a Shiny application \strong{bslib} theme object with Bigelow-style theming.
#' @examples
#' \dontrun{
#' ui <- fluidPage(
#'  theme = bigelow_theme(),
#'  p("Hello World!"))
#' server <- function(input, output, session) {}
#' shinyApp(ui, server)
#' }
bigelow_theme <- function() {
  
  # Basic theme object built using bslib. 
  theme_obj <- bslib::bs_theme(
    version = 5, # Bootstrap refernece version
    # Controls the default grayscale palette
    bg = "white", fg = "#444",
    # Controls the accent (e.g., hyperlink, button, etc) colors
    primary = "#02A5DD", secondary = "#1E4E7B",
    success = "#81AB1F", info = "#02A5DD",
    danger = "#D83838",
    # Local = TRUE stores the font to local cache, but just in case we specify a fallback font
    base_font = bslib::font_collection(bslib::font_google("Open Sans", wght = "300..800", local = TRUE), "Roboto", "sans-serif"), 
    code_font = c("Courier", "monospace"),
    heading_font = bslib::font_collection(bslib::font_google("Open Sans", wght = "300..800"), "Roboto", "sans-serif"), 
    # Additional bootstrap variables we're overriding
    "input-border-color" = "#CCCCCC",
    "border-radius" = "0",
    # Card defaults
    "card-border-radius" = "0",
    "card-inner-border-radius" = "0",
    # Navbar defaults
    "border-color" = "#CCC",
    "nav-tabs-link-active-color" = "#1E4E7B"
  )
  
  # Additional CSS specifies custom rules for classes, additional variables, and styles
  # cssPath <- "/mnt/ecocast/projects/students/ojohnson/bigelow-shiny-theme/bigelowStyles.css"
  cssPath <- system.file("bigelowStyles.css", package = "bigelowshinytheme")
  bigelow_css <- readChar(cssPath, nchars = file.info(cssPath)$size)
  
  theme_obj |>
    bslib::bs_add_rules(bigelow_css)
}

#' Applies bigelow-style theme colors to \strong{ggplot2}, \strong{base}, and \strong{lattice} graphics within an R Shiny application. Wraps \code{\link[thematic]{thematic_shiny}}.
#' @export
#' @param accent a color for making certain graphical markers 'stand out', i.e. fitted line color in \code{\link[ggplot2]{geom_smooth}}. Default color is Bigelow sky blue, replace if high contrast required.
#' @param sequential a color palette for graphical markers encoding numeric values. Can be a vector of color codes or a \code{\link[thematic]{sequential_gradient}} object. Defaults to \code{\link[viridis]{viridis}} color scheme, which is colorblind safe.
#' @param qualitative a color palette for graphical markers that encode qualitative values. Defaults to \code{\link[thematic]{okabe_ito}}, which is verified to be colorblind safe.
#' @return global theme object.
#' @examples
#' \dontrun{
#' bigelow_style_plots()
#' shinyApp(ui, server)
#' }
bigelow_style_plots <- function(
    accent = "#02A5DD",
    sequential = viridis::viridis(4), 
    qualitative = thematic::okabe_ito()) {
  
  thematic::thematic_shiny(bg = "white", 
                           fg = "#444", 
                           accent = accent, 
                           font = thematic::font_spec(families = c("Open Sans", "Roboto"), scale = 1.2), 
                           sequential = sequential, 
                           qualitative = qualitative, 
                           inherit = FALSE)
}

#' Creates and returns a Bigelow-style header for an R Shiny application.
#' @export 
#' @param left_hand, div, material to have on left hand side of footer.
#'  If this is pure text it is parsed to a header element
#' @param right_hand, div, material to have on right hand side of footer or NULL
#' @return div, footer element with bigelow logo.
#' @examples
#' \dontrun{
#' ui <- shiny::fluidPage(
#'  theme = bigelow_theme(), 
#'  bigelow_header("Header text"), 
#'  bigelow_main_body(
#'    p("Hello World!")
#'  ), 
#'  bigelow_footer("Footer text"))
#' server <- function(input, output, session) {}
#' shiny::shinyApp(ui, server)
#' }
bigelow_header <- function(left_hand, right_hand = NULL) {
  if (inherits(left_hand, "character")) {left_hand <- htmltools::h2(left_hand)}
  if (is.null(right_hand)) {
    div(class = "bigelow-header", left_hand)
  } else {
    div(class = c("bigelow-header", "flex-justify"), left_hand, right_hand)
  }
}

#' Creates and returns a Bigelow-style main body for an R Shiny application.
#' Basically just gives the main content a slight padding & restricts max width.
#' @export
#' @rdname bigelow_header
#' @param ..., content
#' @return div, content with wrapped styling
bigelow_main_body <- function(...) {
  div(class = "bigelow-main-body", ...)
}

#' Creates and returns a Bigelow-style footer for an R Shiny application.
#' Required to have bigelow_logo.svg in the www/images folder
#' @export
#' @rdname bigelow_header
#' @return div, footer element with bigelow logo.
bigelow_footer <- function(left_hand) {
  div(class = c("bigelow-footer", "flex-justify"),
      left_hand,
      htmltools::img(src='images/bigelow_logo.svg', alt = "Bigelow Laboratory Logo"))
}

#' Creates and returns a Bigelow-style plot card with optional header, main content, 
#' and optional footer
#' @export
#' @param headerContent content, text to put in header
#' @param footerContent content, text to put in footer
#' @param ... content to put in main body, typically a plot
#' @examples
#' \dontrun{
#' bigelow_card(headerContent = "Plot title", 
#'  plotOutput("plot_id"))
#' }
bigelow_card <- function(..., headerContent = NULL, footerContent = NULL) {
  header_div <- if (is.null(headerContent)) {NULL} else {div(class = "card-header", headerContent)}
  footer_div <- if (is.null(footerContent)) {NULL} else {div(class = "card-footer", footerContent)}
  body <- div(class = "card-body", ...)
  
  arg_list <- Filter(Negate(is.null), list(class = c("card", "bigelow-card"), header_div, body, footer_div))
  
  do.call(div, arg_list)
}


