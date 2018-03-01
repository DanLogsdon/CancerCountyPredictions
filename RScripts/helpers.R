# Note: percent map is designed to work with the counties data set
# It may not work correctly with other data sets if their row order does 
# not exactly match the order in which the maps package plots counties
percent_map <- function(var, color, legend.title, min=1 , max=5, smoking, diabetes, pm, bp, hisp) {

  # generate vector of fill colors for map
  shades <- colorRampPalette(c("white", color))(5)
  
  #setting cancer incidence to default
  if (smoking==1 & diabetes ==1 & pm==1 & bp==1 & hisp==1){
    smoking=smoking
    diabetes=diabetes
    pm=pm
    bp=bp
    hisp=hisp
  }else{
    variables = c(smoking, diabetes, pm, bp, hisp)
    write.csv(variables, file = "fromr.csv")
    system('C:/Users/593419/AppData/Local/Continuum/anaconda2/pythonw.exe GenerateNewMap.py')
    var <- read.csv("fromp.csv")
    var=var$Cancer
  }
  

  
  # constrain gradient to percents that occur between min and max
  var <- pmax(var, min)
  var <- pmin(var, max)
  percents <- as.integer(cut(var, 5, 
    include.lowest = TRUE, ordered = FALSE))
  fills <- shades[percents]

  # plot choropleth map
  map("county", fill = TRUE, col = fills, 
    resolution = 0, lty = 0, projection = "polyconic", 
    myborder = 0, mar = c(0,0,0,0))
  
  # overlay state borders
  map("state", col = "white", fill = FALSE, add = TRUE,
    lty = 1, lwd = 1, projection = "polyconic", 
    myborder = 0, mar = c(0,0,0,0))
  
  # add a legend
  inc <- (max - min) / 4
  legend.text <- c(paste0(1, " (low cancer incidence)"),
    paste0(2, " (mid-low cancer incidence)"),
    paste0(3," (mid cancer incidence)" ),
    paste0(4, " (mid-high cancer incidence)" ),
    paste0(5," (high cancer incidence)"))
  
  legend("bottomleft", 
    legend = legend.text, 
    fill = shades[c(1, 2, 3, 4, 5)], 
    title = legend.title)
}