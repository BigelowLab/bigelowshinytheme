suppressPackageStartupMessages({
  library(shiny)
  library(bslib)
  library(bigelowshinytheme)
  library(dplyr)
  library(leaflet)
  library(ggplot2)
})

# Creates an example Shiny website highlighting supported features of the Bigelow Shiny theme object

s <- dplyr::storms |>
  mutate(date = as.POSIXct(sprintf("%s-%s-%s %s:00", year, month, day, hour))) 

ui <- shiny::fluidPage(
  theme = bigelowshinytheme::bigelow_theme(),
  includeCSS("www/additionalStyles.css"),
  
  # Header
  bigelowshinytheme::bigelow_header(
    h2("Bigelow Shiny Theme"), h6("Tutorial")),
  
  # Main content
  bigelowshinytheme::bigelow_main_body(
    # Introduction
    p("The Bigelow Shiny theme is a package that provides pre-built theming for shiny components as well as a handful of custom functions for structuring your Shiny application. This demo app highlights key functionality and supported features."),
    p("To add Bigelow Theming to your Shiny application, add ", code("theme = bigelow_theme()"), "as the first argument to your ui object. To mirror styling to plot objects, call ", code("bigelow_style_plots()"), " immediately before your call to ", code("shiny::shinyApp()"), "."),
    
    p(style = "color: var(--danger); font-weight: bold;", "NOTE: The Bigelow Shiny theme REMOVES default padding on the main body element so that navbars, headers, and footers extend across the page. Use bigelow_main_body() or custom styling to add padding for main content."),
    
    br(),
    
    # Usage documentation
    h2("Usage"),
    
    p("Shiny applications draw from the ", code("www/"), " directory to render styles and images.", code("copy_www()"), "copies a www folder and supporting images to your home directory which are necessary for ", code("bigelowshinytheme"), " functions."),
    
    p("After adding a ", code("bigelow_theme()"), " object to your code, most Shiny elements are automatically formatted, including navigation bars, UI inputs, and default ggplot styles. If you wish to override a specific style, refer to the 'additionalStyles.css' file in your www directory for information on overriding CSS."),
    
    p("The", code("bigelowshinytheme"), "package also contains three structural helper functions for essential components of your site."),
    HTML("<ul>
         <li><code>bigelow_header()</code> renders a header object with a right hand and optional left hand component. It also renders a grey border line underneath. For multi-tab applications, replace <code>bigelow_header()</code> with <code>bslib::navset_bar()</code>, which will be styled automatically. </li>
         <li><code>bigelow_main_body()</code> is a wrapper for any main body elements (or individual tab panels, for multi-panel sites). It adds simple styling parameters such as padding and max width for readability on large screens. </li>
         <li><code>bigelow_footer()</code> adds a Bigelow-style footer element at the bottom of the screen. It includes customizable right-hand content and the Bigelow logo. </li>
         </ul>"),
    verbatimTextOutput("structure_functions_codeblock"),
    
    p("Finally, the ", code("bigelow_card()"), " function can be used to create a bounding box for plots or charts with distinct header and/or footer elements."),
    
    verbatimTextOutput("bigelow_card_codeblock"),
    
    br(), 
    
    ## Detailed interaction menu displaying styling defaults
    
    h2("Default styling examples"),
    
    p("See the below navigation menu and UI inputs for basic demonstration of automatic styling and ", code("bigelow_card()"), "."),
    
    navset_bar(
      title = "Navigation Bar",
      # Showcase of basic plots
      nav_panel("Plots", 
                selectInput("storm_choice",
                            "Choose a storm to plot",
                            choices=sort(unique(s$name)),
                            selected="Hugo"),
                div(style = "height: 70vh; overflow-x: auto; display: flex;",
                    div(style = "width: 68vh; flex-shrink: 0; margin: 1vh;", 
                        bigelowshinytheme::bigelow_card(headerContent = "(Header) Storm Record",
                                     leafletOutput("storm_record", width = "100%", height = "100%"))),
                    div(style = "width: 68vh; flex-shrink: 0; margin: 1vh;", 
                        bigelowshinytheme::bigelow_card(footerContent = "Footer", headerContent = "Wind vs. Force", 
                                     plotOutput("scatter_plot"))),
                    div(style = "width: 68vh; flex-shrink: 0; margin: 1vh;", 
                        bigelowshinytheme::bigelow_card(footerContent = "(Footer) Wind over time", headerContent = NULL, 
                                     plotOutput("wind_plot")))
                )),
      # Showcase of UI Inputs and accompanying code snippets
      nav_panel("Sidebar & Inputs",
                navlistPanel(
                  "Sidebar Title",
                  tabPanel("Date Input", 
                           dateInput("dateSelect", "Choose a date (nonfunctional)"),
                           code('dateInput("id", "label_text")')),
                  tabPanel("Slider Input", 
                           sliderInput("sliderSelect", "Choose a number", 5, 10, 7),
                           code('sliderInput("id", "label", min, max, value)')),
                  tabPanel("Radio Buttons", 
                           radioButtons("radioSelect", "Choose a button", choices = c("Option 1", "Option 2")),
                           code('radioButtons("id", "label", choices = c("A", "B"))')),
                  tabPanel("Checkbox", 
                           checkboxInput("checkboxInput", "Check box?", value = FALSE),
                           code('checkboxInput("id", "label", value = FALSE)')),
                  tabPanel("Text Input", 
                           textInput("textSelect", "Enter some text", placeholder = "Type here..."),
                           code('textInput("id", "label", placeholder = "text")')),
                  tabPanel("Numeric Input", 
                           numericInput("numericSelect", "Enter a number", value = 42, min = 0, max = 100),
                           code('numericInput("id", "label", value = 0, min = 0, max = 100)')),
                  tabPanel("Select Input", 
                           selectInput("selectInput", "Choose from dropdown", 
                                       choices = c("Choice A", "Choice B", "Choice C"), 
                                       selected = "Choice A"),
                           code('selectInput("id", "label", choices = c("A", "B", "C"))')),
                  tabPanel("File Upload", 
                           fileInput("fileSelect", "Choose a file", accept = c(".csv", ".txt")),
                           code('fileInput("id", "label", accept = c(".csv", ".txt"))')),
                  tabPanel("Multiple Choice", 
                           checkboxGroupInput("multiSelect", "Select multiple options",
                                              choices = c("Item 1", "Item 2", "Item 3", "Item 4"),
                                              selected = c("Item 1")),
                           code('checkboxGroupInput("id", "label", choices = c("A", "B", "C"))'))
                )),
      nav_spacer(),
      # Showcase of dropdown menu styling & Navigation bars
      nav_menu("Dropdown",
               nav_panel("Other Navbars", 
                         # Standard navset_tab
                         card(
                           card_header("navset_tab - Standard tabs"),
                           navset_tab(
                             nav_panel("Tab 1", p("Standard tab panel content 1")),
                             nav_panel("Tab 2", p("Standard tab panel content 2")),
                             nav_panel("Tab 3", p("Standard tab panel content 3"))
                           )
                         ),
                         br(),
                         # navset_pill
                         card(
                           card_header("navset_pill - Pill-style navigation"),
                           navset_pill(
                             nav_panel("Pill 1", p("Pill navigation content 1")),
                             nav_panel("Pill 2", p("Pill navigation content 2")),
                             nav_panel("Pill 3", p("Pill navigation content 3"))
                           )
                         ),
                         br(),
                         # navset_underline
                         card(
                           card_header("navset_underline - Underlined tabs"),
                           navset_underline(
                             nav_panel("Under 1", p("Underlined tab content 1")),
                             nav_panel("Under 2", p("Underlined tab content 2")),
                             nav_panel("Under 3", p("Underlined tab content 3"))
                           )
                         )
               ),
               nav_panel("Dummy Item", p("Boo!")),
               nav_item(tags$a("Dummy Link", href = "#", target = "_blank"))
      )
    )
  ),
  # Footer with bigelow logo
  bigelowshinytheme::bigelow_footer("Last updated October 2025")
)

server <- function(input, output, session) {
  
  # Specify code block strings
  output$structure_functions_codeblock <- renderText(
    'library(bigelowshinytheme)
  
if (!dir.exists("www")) {bigelowshinytheme::copy_www()}
  
ui <- fluidPage(
  theme = bigelow_theme(), 
  bigelow_header("Header"),
  bigelow_main_body(
    "Hello World!"
  ), 
  bigelow_footer("Footer")
)

server <- function(input, output, session) {}

bigelow_style_plots()
shiny::shinyApp(ui, server)')

output$bigelow_card_codeblock <- renderText(
  'bigelow_card(headerContent = "Header Text",
             footerContent = NULL,
             p("Text in body"),
             plotOutput("plotBodyContent"))')


# Specify plot outputs
stormdata <- reactive({s |>
    filter(name == input$storm_choice) |>
    arrange(date)})

output$wind_plot <- renderPlot({
  ggplot(stormdata(), aes(x=date)) + 
    geom_line(aes(y=wind)) + 
    ggtitle("Accent color doesn't apply to single color geoms.")
})

output$storm_record <- renderLeaflet({
  data <- stormdata()
  
  custom_icon <- makeIcon(
    iconUrl = "www/images/record.png",
    iconWidth = 21,
    iconHeight = 28, 
    iconAnchorX = 10,
    iconAnchorY = 28
  )
  
  leaflet(data = data) |>
    addTiles() |>
    addMarkers(~long, ~lat, icon = custom_icon)
})

output$scatter_plot <- renderPlot({
  ggplot(stormdata(), aes(x = wind, y = pressure)) + 
    geom_jitter(aes(color = long)) + 
    geom_smooth()
})
}

# Applying ggplot styling and render app
bigelowshinytheme::bigelow_style_plots()
shinyApp(ui, server)
