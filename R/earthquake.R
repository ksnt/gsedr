#' Clean Location Data
#'
#' This is a simple function that cleans data
#'
#' @param data Dataframe
#' @return This function returns a dataframe.
#'
#' @importFrom dplyr %>% mutate_
#' @importFrom stringr str_replace str_trim str_to_title
#' @importFrom lubridate year
#'
#' @examples
#' library(stringr)
#' library(dplyr)
#' library(lubridate)
#' datapath <- system.file("extdata", "earthquakes.txt", package = "gsedr")
#' after2000data <- readr::read_delim(datapath, delim = "\t") %>% eq_clean_data()  %>% dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000)
#'
#'
#' @export
eq_location_clean <- function(data){
  data <- data %>%
    dplyr::mutate_(LOCATION_NAME = ~LOCATION_NAME %>%
                     stringr::str_replace(paste0(COUNTRY,":"),"") %>%
                     stringr::str_trim("both") %>%
                     stringr::str_to_title()
    )
  data
}


#' Clean Data
#'
#' This is a simple function that cleans data
#'
#' @param data The data to be analyzed
#' 
#' @return This function returns a dataframe.
#'
#' @importFrom dplyr %>% mutate_
#' @importFrom stringr str_c
#' @importFrom lubridate year
#'
#' @examples
#' library(stringr)
#' library(dplyr)
#' library(lubridate)
#'
#' datapath <- system.file("extdata", "earthquakes.txt", package = "gsedr")
#' after2000data <- readr::read_delim(datapath, delim = "\t") %>% eq_clean_data()  %>% dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000)
#'
#'
#' @export
eq_clean_data <- function(data){
    data <- data %>%
            dplyr::mutate_(DATE = ~stringr::str_c(formatC(YEAR,width=4,flag="0"), '', formatC(MONTH,width = 2,flag = "0"), '', formatC(DAY,width = 2,flag = "0")))
    data$DATE <- as.character(data$DATE)
    data$DATE <- as.Date(data$DATE, "%Y%m%d")
    data$LATITUDE <- as.numeric(data$LATITUDE)
    data$LONGITUDE <- as.numeric(data$LONGITUDE)
    data <- eq_location_clean(data)
    data
}
