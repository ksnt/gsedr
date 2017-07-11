[![Build Status](https://travis-ci.org/ksnt/gsedr.svg?branch=master)](https://travis-ci.org/ksnt/gsedr)


## Overview

"GeoSpatial Earth Data analysis in R"(gsedr) library  


author: ksnt  
Dataset: https://www.ngdc.noaa.gov/nndc/struts/form?t=101650&s=1&d=1  






## How to install

```{r setup, include=FALSE}
install.packages("devtools")
library(devtools)
install_github("https://github.com/ksnt/gsedr")
```

## Retrieve and Tidy Data

Use `eq_clean_data` function.(`eq_location_clean` function is used in this function)  

```{r "eq_clean_data", eval=FALSE}
# Retrieve earthquake data after 2000 a.c. in Mexico 
datapath <- system.file("extdata", "earthquakes.txt", package = "gsedr")
after2000data <- readr::read_delim(datapath, delim = "\t") %>%
　　　　　　　　　　eq_clean_data()  %>%
          　　　　dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000)
```


## Create Timeline

Use `geom_timeline_label` function.

```{r "geom_timeline_label", eval=FALSE}
# Retrieve earthquake data after 1900 in JAPAN, TURKEY, HAITI, and INDONESIA.
# Create time-line plot

datapath <- system.file("extdata", "earthquakes.txt", package = "gsedr")
data <- readr::read_delim(datapath, delim = "\t") %>% eq_clean_data()
ddd <- data %>% dplyr::filter(COUNTRY %in% c('USA', 'JAPAN','TURKEY','HAITI','INDONESIA')) %>%
　　　　dplyr::filter(!is.na(EQ_PRIMARY), !is.na(DEATHS)) %>% dplyr::filter(YEAR > 1900)
ddd %>% ggplot(aes(x=DATE,y=COUNTRY,size=as.numeric(EQ_PRIMARY),colour=as.numeric(TOTAL_DEATHS))) +
　　　　　　　　　geom_point(alpha=0.6) +
         　　　　geom_timeline_label(aes(label = LOCATION_NAME), n_max = 3) +
             　scale_colour_gradient(low="skyblue",high = "red") +
              　annotate("text", label = "ship", parse=TRUE) + labs(size = "Richter scale value", color = "# deaths") +
               theme_minimal()
```

***Time-line plot***  
![timeline](https://user-images.githubusercontent.com/530390/28039084-00a1c21e-65fc-11e7-8b14-48d2a6e63498.png)


## Create Map

Use `eq_create_label` function and `eq_map` function.


```{r "eq_create_label", eval=FALSE}
# Retrieve earthquake data in INDONESIA.
# Create a map with data

datapath <- system.file("extdata", "earthquakes.txt", package = "gsedr")
data <- readr::read_delim(datapath, delim = "\t") %>% eq_clean_data()
dddd <- data %>% dplyr::filter(COUNTRY %in% c('INDONESIA')) %>%
　　　　　dplyr::filter(!is.na(EQ_PRIMARY), !is.na(DEATHS))
dddd %>% dplyr::mutate(popup_text = eq_create_label(.)) %>%
　　　　　eq_map(annot_col = "popup_text")
```

***Map plot***  
![map01](https://user-images.githubusercontent.com/530390/28038958-a0521062-65fb-11e7-9074-a672a4400bf6.png)
