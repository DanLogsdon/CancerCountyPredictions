###
### Author: Elaine Pak
###


###
### Data Preparation
###
# Set up libraries
library(dplyr)
library(purrr)
library(shiny)
library(leaflet)
library(yaml)
library(RColorBrewer)
library(sp)
library(rgdal)
library(spdplyr)
library(geojsonio)
library(rmapshaper)
library(rgeos)
library(ggplot2)
library(plyr)

# Bring in the shapefiles from US Census
shapes <- readOGR(dsn = "cb_2015_us_county_500k", layer = "cb_2015_us_county_500k", verbose = F)
shapes <- shapes %>%
  filter(!(STATEFP == "02" | STATEFP == "60" | STATEFP == "66" | STATEFP == "15" | STATEFP == "72" | STATEFP == "78")) # get rid of non-mainland states

# Bring in the cancer data
counties <- read.csv("data/rdata.csv", stringsAsFactors = F)


###
### Data Cleaning
###
# Make data more readable
counties$Cancer[which(is.na(counties$Cancer) == TRUE)] = 0 # change NA to 0 to ease future computation
counties$LungCancer = 3 # add an arbitrary new column with all 3 as a value
counties$FIPS[1:285] <- paste0("0", counties$FIPS[1:285]) # change 4-digit FIPs to 5-digit
counties$name <- gsub(",", ", ", counties$name) %>% # for each county name, add space after comma, and
  gsub("(^|[[:space:]])([[:alpha:]])", "\\1\\U\\2", ., perl = T) # capitalize every word
colnames(counties) <- c("number", "layerId", "GEOID", "Cancer", "LungCancer") # change column names

# Merge the two data sets
shapes <- inner_join(shapes, counties, by=c("GEOID")) # retain only rows in both data sets (otherwise the map gets messed up)


###
### R Shiny portion
###
ui <- fluidPage(
  #tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
    
    title = "Total Exposure on Cancer Visualization",
    
    leafletOutput("CAmap", width = "100%", height = "400px"), # main map
    
    fluidRow(
      column(2,
             h4("Choose Type of Cancer"), # dropdown menu to choose type of cancer
             selectInput("var", 
                         label = "Types of Cancer",
                         choices = c("Total Cancer", "Lung Cancer"),
                         selected = "Total Cancer")
             ),
      column(4,
             h4(paste0("Selected County", ": ")),
             textOutput("countyName"), # selected county name
             leafletOutput("countyMap", width = "100%", height = "250px") # selected county map
      ),
      column(3,
             h4("Change Variables"), # 3 sliders
             sliderInput("range", 
                         label = "Cancer Incidence Range:",
                         min = 1, max = 5, value = c(1, 5)),
             sliderInput("smoking", 
                         label = "Smoking Level:",
                         min = 0, max = 2, value = 1, step=0.1),
             sliderInput("diabetes", 
                         label = "Limited Exercise:",
                         min = 0, max = 2, value = 1, step=0.1)
             ),
      column(3,
             h4("Change Variables"), # 3 sliders
             sliderInput("pm", 
                         label = "PM 2.5 Level:",
                         min = 0, max = 2, value = 1, step=0.1),
             sliderInput("BP", 
                         label = "Chemical: DEHP Emitted",
                         min = 0, max = 2, value = 1, step=0.1),
             sliderInput("hisp", 
                         label = "Chemical: MTBE Emitted",
                         min = 0, max = 2, value = 1, step=0.1)
             )
    )
)


server <- function(input, output, session) {

  map <- leaflet(data = shapes) %>% addTiles() %>% setView(-100, 38, 4) # the main map frame 
  
  levelCancer <- c("Missing",1,2,3,4,5) # legend color palette
  pal <- colorFactor(
    palette = c('#cccccc', # missing color is grey
                '#ffffb2', '#fecc5c', '#fd8d3c', '#f03b20', '#bd0026'), # 1 - 5 in red color scale
    levels = levelCancer)
  
  labels <- sprintf( # design element for mouse-over pop-up label
    "<strong>%s</strong><br/>",
    shapes$NAME
  ) %>% lapply(htmltools::HTML)
  
  finalMap <- reactive({ # user's choice in the dropdown menu dictates the main map's result
    if (input$var == "Total Cancer"){ # user's choice in the dropdown menu: Total Cancer
      return(map %>% addPolygons(
        fillColor = ~pal(Cancer), weight = 1, opacity = 1, color = "white",
        dashArray = "3", fillOpacity = 0.7,
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"),
        layerId = shapes$layerId
        ) %>% addLegend(
          pal = pal, values = ~levelCancer, opacity = 0.7, title = "Cancer Likelihood",
          position = "bottomright"
        )
      )
      
    }
    else{ # user's choice in the dropdown menu: Lung Cancer
      return(map %>% addPolygons(
        fillColor = ~pal(LungCancer), weight = 1, opacity = 1, color = "white",
        dashArray = "3", fillOpacity = 0.7,
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"),
        layerId = shapes$layerId
        ) %>% addLegend(
          pal = pal, values = ~levelCancer, opacity = 0.7, title = "Cancer Likelihood",
          position = "bottomright"
        )
      )
    }
  })
  
  output$CAmap <- renderLeaflet({finalMap()}) # the main map
  
  observeEvent(input$CAmap_shape_click, { # user's choice of county returns the county map and name
    click <- input$CAmap_shape_click
    eachCounty <- leaflet(data = shapes[which(shapes$layerId == click$id),])
    
    countyFinalMap <- reactive({ # user's choice of county dictates the county map and name
      ####
      # return FIPS code of the selected county;  add read csv file; return 
      # add a button that returns to default variables of sliders
      ####
    if (input$var == "Total Cancer"){
      return(eachCounty %>% addPolygons(fillColor = ~pal(Cancer), weight = 2, opacity = 1,
                                        color = "white", dashArray = "3", fillOpacity = 0.7))
    }
    else{
      return(eachCounty %>% addPolygons(fillColor = ~pal(LungCancer), weight = 2, opacity = 1,
                                        color = "white", dashArray = "3", fillOpacity = 0.7))
    }
    })
    output$countyName <- renderText({click$id}) # county name in the format of "State, County"
    output$countyMap <- renderLeaflet({countyFinalMap()}) # county map
  })
}

# Run
shinyApp(ui, server)






###
### Trash codes
###
###### Testing GeoJSON ######
shapes_j <- geojson_json(shapes) # convert to json files for even faster testing
shapes_j <- ms_simplify(shapes_j) # reduce the size of the json file
# county_json_clipped <- ms_clip(county_json_simplified, bbox = c(-170, 15, -55, 72)) # for future use - clipping away states not in the northern hemisphere (for visual purposes)

center_CA <- gCentroid(shapes_CA, byid = T)
center_CA <- SpatialPointsDataFrame(center_CA, data= shapes_CA@data, match.ID=F) # column 14 and 15 are double lat and long
