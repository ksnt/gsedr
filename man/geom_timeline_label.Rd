% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geom_timeline.R
\name{geom_timeline_label}
\alias{geom_timeline_label}
\title{Geom for Timeline Data}
\usage{
geom_timeline_label(mapping = NULL, data = NULL, stat = "identity",
  position = "identity", ..., na.rm = FALSE, n_max = NULL,
  show.legend = NA, inherit.aes = TRUE)
}
\arguments{
\item{mapping}{Mapping}

\item{data}{Data}

\item{stat}{Stat}

\item{position}{position}

\item{...}{nothing special}

\item{na.rm}{Whether remove NA or not}

\item{n_max}{Maximum number of labels}

\item{show.legend}{Show legend}

\item{inherit.aes}{Inherit aes}
}
\description{
This is a simple geom function to display
}
\examples{
library(ggplot2)
library(dplyr)
library(grid)

datapath <- system.file("extdata", "earthquakes.txt", package = "gsedr")
data <- readr::read_delim(datapath, delim = "\\t") \%>\% eq_clean_data()
ddd <- data \%>\% dplyr::filter(COUNTRY \%in\% c('USA', 'JAPAN','TURKEY','HAITI','INDONESIA')) \%>\% dplyr::filter(!is.na(EQ_PRIMARY), !is.na(DEATHS)) \%>\% dplyr::filter(YEAR > 1900)
ddd \%>\% ggplot(aes(x=DATE,y=COUNTRY,size=as.numeric(EQ_PRIMARY),colour=as.numeric(TOTAL_DEATHS))) + geom_point(alpha=0.6) + geom_timeline_label(aes(label = LOCATION_NAME), n_max = 3) + scale_colour_gradient(low="skyblue",high = "red") + annotate("text", label = "ship", parse=TRUE) + labs(size = "Richter scale value", color = "# deaths") + theme_minimal()


}
