library(jsonlite)
d=readRDS('data/COVID-19-up-to-date.rds')
countries <- c(
  "Denmark",
  "Italy",
  "Germany",
  "Spain",
  "United_Kingdom",
  "France",
  "Norway",
  "Belgium",
  "Austria", 
  "Sweden",
  "Switzerland",
  "Greece",
  "Portugal",
  "Netherlands"
)
verify_web_output <- function(){
  plot_names <- c("deaths", "forecast", "infections", "rt")
  plot_versions <- c("mobile", "desktop")
  
  args <- commandArgs(trailingOnly = TRUE)
  filename2 <- args[1]
  load(paste0("results/", filename2))
  print(sprintf("loading: %s",paste0("results/",filename2)))
  
  date_results <- list()
  
  for(country in countries) {
    for (plot_version in plot_versions) {
      for (plot_name in plot_names) {
        path = sprintf("web/figures/%s/%s_%s.svg", plot_version, country, plot_name)
        
        if (! file.exists(path)) {
          stop(sprintf("Missing web output during verification: %s", path))
        }
      }
    }
    
    d1=d[d$Countries.and.territories==country,]
    d1$date = as.Date(d1$DateRep,format='%d/%m/%Y')
    latest_date = max(d1$date)
    date_results[[country]] = latest_date
    
  }
  
  
  dir.create("web/data/", showWarnings = FALSE, recursive = TRUE)
  write_json(date_results, "web/data/latest-updates.json", auto_unbox=TRUE)
}

verify_web_output()