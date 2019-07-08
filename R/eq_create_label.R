#'Add more information to map popups
#'
#'Function that adds additional information to popups creates with the \code{\link{eq_map}} function of the
#'`earthquakesAJS`` package.
#'Function to be used with NOAA earthquake data downloaded and cleaned with the \code{\link{eq_read_data}} and
#'\code{\link{eq_clean_data}} functions of the `earthquakesAJS`` package.
#'
#'@param data NOAA earthquake data from which to exract information
#'
#'@return A HTML label containing information of the location, magnitude and severity (total deaths) of
#'earthquakes, if corresponding information is present in the input data
#'
#' @examples
#' \dontrun{
#' url<-"https://www.example-url.org"
#' ds <- eq_location_clean(eq_clean_data(ds))
#' dplyr::filter(ds, COUNTRY  %in% c("USA") & lubridate::year(DATE) >= 1960) %>%
#' dplyr::mutate(popup_text = eq_create_label(.)) %>%
#' eq_map(annot_col = "popup_text")
#'}
#'
#'@export
eq_create_label <- function(data){
    paste(ifelse(is.na(data$LOCATION_NAME),"", paste("<b>Location: </b>",data$LOCATION_NAME,"<br/>")),
          ifelse(is.na(data$EQ_PRIMARY),"", paste("<b>Magnitude: </b>",data$EQ_PRIMARY,"<br/>")),
          ifelse(is.na(data$TOTAL_DEATHS),"", paste("<b>Total deaths: </b>",data$TOTAL_DEATHS,"<br/>")))
    }








