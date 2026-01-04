library(shiny)
library(ggplot2)
library(dplyr)
library(maps)
library(viridis)
library(plotly)

#Loading processed data
new_data <- read.csv("final_data.csv", stringsAsFactors = FALSE)
new_data$Countries <- trimws(new_data$Countries)

#Loading map data
world_map <- map_data("world")

#Identifying numeric columns for the variable selector
numeric_vars <- names(new_data)[sapply(new_data, is.numeric)]

#Creating function to format variable names
format_var_name <- function(var_name) {
  #Replacing periods and underscores with spaces
  formatted <- gsub("[._]", " ", var_name)
  #Capitalizing first letter of each word
  formatted <- tools::toTitleCase(formatted)
  return(formatted)
}

#Creating named vector for selectInput with formatted labels
numeric_vars_formatted <- setNames(numeric_vars, sapply(numeric_vars, format_var_name))

#Shiny App Set Up
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      }
      .container-fluid {
        padding: 20px;
      }
      .well {
        background: rgba(255, 255, 255, 0.95);
        border: none;
        border-radius: 15px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        padding: 25px;
      }
      .main-panel {
        background: rgba(255, 255, 255, 0.95);
        border-radius: 15px;
        padding: 25px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
      }
      h2 {
        color: #667eea;
        font-weight: 700;
        text-align: center;
        margin-bottom: 30px;
        text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
      }
      .control-label {
        color: #4a5568;
        font-weight: 600;
        font-size: 14px;
        margin-bottom: 8px;
      }
      .selectize-input {
        border: 2px solid #e2e8f0;
        border-radius: 8px;
        padding: 10px;
        transition: all 0.3s ease;
      }
      .selectize-input:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
      }
      .selectize-dropdown {
        border-radius: 8px;
        border: 2px solid #e2e8f0;
      }
      .selectize-dropdown-content .option {
        padding: 8px 12px;
      }
      .shiny-input-container {
        margin-bottom: 20px;
      }
      #map {
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
      }
      .map-title {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 25px;
        border-radius: 12px 12px 0 0;
        margin: -25px -25px 20px -25px;
        text-align: center;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      }
      .map-title h3 {
        margin: 0;
        font-size: 28px;
        font-weight: 700;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
      }
      .map-title p {
        margin: 8px 0 0 0;
        font-size: 16px;
        opacity: 0.95;
      }
    "))
  ),
  
  titlePanel(
    div(style = "text-align: center; color: white; text-shadow: 2px 2px 8px rgba(0,0,0,0.3);",
        h2(style = "color: white; margin-top: 20px; font-size: 36px;", 
           "🌍 Economic Freedom of the World"),
        p(style = "color: rgba(255,255,255,0.9); font-size: 16px;", 
          "Interactive Choropleth Visualization")
    )
  ),
  
  sidebarLayout(
    sidebarPanel(
      style = "background: rgba(255, 255, 255, 0.95); border-radius: 15px; padding: 25px; box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);",
      
      div(style = "text-align: center; margin-bottom: 20px;",
          icon("sliders", style = "font-size: 32px; color: #667eea;"),
          h4(style = "color: #4a5568; margin-top: 10px;", "Controls")
      ),
      
      selectInput("year", 
                  label = div(icon("calendar"), " Select Year"),
                  choices = sort(unique(new_data$Year)),
                  selected = max(new_data$Year)),
      
      selectInput("variable", 
                  label = div(icon("chart-line"), " Select Variable"),
                  choices = numeric_vars_formatted,
                  selected = numeric_vars[1]),
      
      hr(style = "border-top: 2px solid #e2e8f0;"),
      
      div(style = "background: #f7fafc; padding: 15px; border-radius: 8px; margin-top: 20px;",
          p(style = "margin: 0; color: #4a5568; font-size: 13px;",
            icon("info-circle"), 
            " Select a year and variable to visualize global patterns on the map above.")
      )
    ),
    
    mainPanel(
      style = "background: rgba(255, 255, 255, 0.95); border-radius: 15px; padding: 25px; box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);",
      
      div(class = "map-title",
          uiOutput("mapTitle")
      ),
      
      plotlyOutput("map", height = "650px")
    )
  )
)

server <- function(input, output) {
  
  output$mapTitle <- renderUI({
    var_display_name <- format_var_name(input$variable)
    
    div(
      h3(var_display_name),
      p(paste("Year:", input$year))
    )
  })
  
  output$map <- renderPlotly({
    
    #Getting formatted variable name for display
    var_display_name <- format_var_name(input$variable)
    
    #Filtering and aggregate data by country
    plot_data <- new_data |>
      filter(Year == input$year) |>
      group_by(Countries) |>
      summarise(value = mean(.data[[input$variable]], na.rm = TRUE), .groups = 'drop')
    
    #Joining with map polygons
    map_df <- world_map |>
      left_join(plot_data, by = c("region" = "Countries")) |>
      filter(region != "Antarctica")
    
    #Base ggplot choropleth
    p <- ggplot(map_df, aes(long, lat, group = group, fill = value,
                            text = paste0("<b>", region, "</b><br>",
                                          format_var_name(input$variable), ": ", 
                                          ifelse(is.na(value), "No data", round(value, 2))))) +
      geom_polygon(color = "white", linewidth = 0.2) +
      coord_quickmap() +
      scale_fill_viridis_c(option = "plasma", na.value = "#e2e8f0",
                           begin = 0.1, end = 0.9) +
      theme_minimal(base_size = 14) +
      theme(
        axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        legend.position = "bottom",
        legend.direction = "horizontal",
        legend.title = element_text(size = 13, face = "bold", vjust = 0.8),
        legend.text = element_text(size = 11),
        legend.key.width = unit(2.5, "cm"),
        legend.key.height = unit(0.5, "cm"),
        panel.background = element_rect(fill = "#f7fafc", color = NA),
        plot.background = element_rect(fill = "transparent", color = NA),
        plot.margin = margin(5, 5, 5, 5)
      ) +
      labs(fill = var_display_name)
    
    #Converting ggplot to interactive plotly with enhanced layout
    ggplotly(p, tooltip = "text") |>
      layout(
        paper_bgcolor = 'transparent',
        plot_bgcolor = 'transparent',
        hoverlabel = list(
          bgcolor = "white",
          font = list(family = "Segoe UI", size = 12),
          bordercolor = "#667eea"
        )
      ) |>
      config(displayModeBar = TRUE, 
             modeBarButtonsToRemove = c("pan2d", "lasso2d", "select2d"),
             displaylogo = FALSE)
  })
}

shinyApp(ui, server)