library(testthat)


datapath <- system.file("extdata", "earthquakes.txt", package = "gsedr")
data <- readr::read_delim(datapath, delim = "\t")

test_that("eq_location_clean function returns dataframe", {expect_is(eq_location_clean(data), "data.frame")})

test_that("eq_clean_data returns a data frame", {
     expect_is(eq_clean_data(data), "data.frame")
})

test_that("geom_timeline_label returns a ggplot object", {
     clean_data <- data %>% eq_clean_data()
     g <- clean_data %>% ggplot2::ggplot(aes(x=DATE,y=COUNTRY,size=as.numeric(EQ_PRIMARY),colour=as.numeric(TOTAL_DEATHS))) + geom_timeline_label(aes(label = LOCATION_NAME), n_max = 3)
     expect_is(g, "ggplot")
})

test_that("eq_map returns a leaflet object", {
     clean_data <- data %>% eq_clean_data()
     dddd <- clean_data %>% dplyr::filter(COUNTRY %in% c('INDONESIA')) %>% dplyr::filter(!is.na(EQ_PRIMARY), !is.na(DEATHS))
     g <- dddd %>% dplyr::mutate(popup_text = eq_create_label(.)) %>% eq_map(annot_col = "popup_text")
     expect_is(g, "leaflet")
})

test_that("eq_map returns a character set",{
     clean_data <- data %>% eq_clean_data()
     dddd <- clean_data %>% dplyr::filter(COUNTRY %in% c('INDONESIA')) %>% dplyr::filter(!is.na(EQ_PRIMARY), !is.na(DEATHS))
     g <- eq_create_label(dddd)
     expect_is(g,"character")
})
