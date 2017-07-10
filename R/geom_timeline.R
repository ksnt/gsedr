#' Geom for Timeline Data
#'
#' This is a simple geom function to display
#'
#' @importFrom ggplot2 layer ggproto aes ggproto ggplot draw_key_blank
#' @importFrom dplyr group_by_ top_n ungroup
#' @importFrom grid polylineGrob gpar textGrob gList
#'
#' @examples
#' library(ggplot2)
#' library(dplyr)
#' library(grid)
#'
#' datapath <- system.file("extdata", "earthquakes.txt", package = "gsedr")

#'data <- readr::read_delim(datapath, delim = "\t") %>% eq_clean_data()
#'ddd <- data %>% dplyr::filter(COUNTRY %in% c('USA', 'JAPAN','TURKEY','HAITI','INDONESIA')) %>% dplyr::filter(!is.na(EQ_PRIMARY), !is.na(DEATHS)) %>% dplyr::filter(YEAR > 1900)
#'ddd %>% ggplot(aes(x=DATE,y=COUNTRY,size=as.numeric(EQ_PRIMARY),colour=as.numeric(TOTAL_DEATHS))) + geom_point(alpha=0.6) + geom_timeline_label(aes(label = LOCATION_NAME), n_max = 3) + scale_colour_gradient(low="skyblue",high = "red") + annotate("text", label = "ship", parse=TRUE) + labs(size = "Richter scale value", color = "# deaths") + theme_minimal()
#'
#'
#' @export
geom_timeline_label <- function(mapping = NULL, data = NULL, stat = "identity",
                                position = "identity", ..., na.rm = FALSE,
                                n_max = NULL, show.legend = NA,
                                inherit.aes = TRUE) {

  ggplot2::layer(
    geom = geom_timeline_proto, mapping = mapping,
    data = data, stat = stat, position = position,
    show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, n_max = n_max, ...)
  )
}

geom_timeline_proto <-
  ggplot2::ggproto(
    "geom_timeline_proto", ggplot2::Geom,
    required_aes = c("x", "label"),
    draw_key = ggplot2::draw_key_blank,
    setup_data = function(data, params) {
      #print(params)
      if (!is.null(params$n_max)) {
        if (!("size" %in% colnames(data))) {
          stop(paste("'size' aesthetics needs to be",
                     "provided when 'n_max' is defined."))
        }
        #print(data)
        data <- data %>%
          dplyr::group_by_("group") %>%
          dplyr::top_n(params$n_max, size) %>% # If we want to use magnitude as text label
          #dplyr::top_n(params$n_max, deaths) %>% # If we want to use the num of deaths as text label
          dplyr::ungroup()
        #print(data)
      }
      data
    },
    draw_panel = function(data, panel_scales, coord, n_max) {

      if (!("y" %in% colnames(data))) data$y <- 0.15

      coords <- coord$transform(data, panel_scales)
      n_grp <- length(unique(data$group))
      offset <- 0.2 / n_grp
      
      lines <- grid::polylineGrob(
        x = unit(c(coords$x, coords$x), "npc"),
        y = unit(c(coords$y, coords$y + offset), "npc"),
        id = rep(1:dim(coords)[1], 2),
        gp = grid::gpar(
          col = "grey"
        )
      )

      names <- grid::textGrob(
        label = coords$label,
        x = unit(coords$x, "npc"),
        y = unit(coords$y + offset, "npc"),
        just = c("left", "bottom"),
        rot = 45
      )

      grid::gList(lines, names)
    }
  )


##################################### MAP ######################################

#' This is a simple funtion for mapping
#'
#' @param data Data
#' @param annot_col A character, which is a column in data to be shown in map
#' @return Leaflet map
#'
#' @importFrom ggplot2 layer ggproto aes ggproto ggplot
#' @importFrom leaflet leaflet addTiles addCircleMarkers
#'
#' @examples
#' library(ggplot2)
#' library(leaflet)
#' library(dplyr)
#'
#' datapath <- system.file("extdata", "earthquakes.txt", package = "gsedr")
#' data <- readr::read_delim(datapath, delim = "\t") %>% eq_clean_data()
#' dddd <- data %>% dplyr::filter(COUNTRY %in% c('INDONESIA')) %>% dplyr::filter(!is.na(EQ_PRIMARY), !is.na(DEATHS))
#' dddd %>% dplyr::mutate(popup_text = eq_create_label(.)) %>% eq_map(annot_col = "popup_text")
#'
#' @export
eq_map <- function(data, annot_col) {
  m <- leaflet::leaflet() %>%
       leaflet::addTiles() %>%
       leaflet::addCircleMarkers(lng = data$LONGITUDE, lat = data$LATITUDE,
                                 radius = as.numeric(data$EQ_PRIMARY) * 1.3, weight = 1,
                                 color = "red", popup = data[[annot_col]],
                                 fillOpacity = 0.7)
  m
}


#' This is a simple funtion for mapping to create label
#'
#' @param data Data
#' @return Character vector
#'
#' @examples
#' library(ggplot2)
#' library(leaflet)
#' library(dplyr)
#'
#' datapath <- system.file("extdata", "earthquakes.txt", package = "gsedr")
#' data <- readr::read_delim(datapath, delim = "\t") %>% eq_clean_data()
#' dddd <- data %>% dplyr::filter(COUNTRY %in% c('INDONESIA')) %>% dplyr::filter(!is.na(EQ_PRIMARY), !is.na(DEATHS))
#' dddd %>% dplyr::mutate(popup_text = eq_create_label(.)) %>% eq_map(annot_col = "popup_text")
#'
#' @export
eq_create_label <- function(data) {
  popup_text <- with(data, {
    t1 <- paste("<strong>Location:</strong>", LOCATION_NAME)
    t2 <- paste("<br><strong>Year:</strong>",YEAR)
    t3 <- paste("<br><strong>Magnitude</strong>", EQ_PRIMARY)
    t4 <- paste("<br><strong>Total Deaths:</strong>",TOTAL_DEATHS)
    paste0(t1, t2, t3, t4)
  })
}
