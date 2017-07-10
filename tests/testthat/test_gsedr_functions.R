library(testthat)


datapath <- system.file("extdata", "earthquakes.txt", package = "gsedr")
data <- readr::read_delim(datapath, delim = "\t")

test_that("eq_location_clean function returns dataframe", {expect_is(eq_location_clean(data), "data.frame")})