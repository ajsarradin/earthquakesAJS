#'Creates a leaflet map of earthquake locations
#'
#'Function that creates a leaflet map of earthquake epicenters with popups containing information on a selected
#'column of the utilised earthquake data.
#'Function to be used with NOAA earthquake data downloaded and cleaned with the \code{\link{eq_read_data}} and
#'\code{\link{eq_clean_data}} functions of the `earthquakesAJS`` package.
#'
#'@param data NOAA earthquake data to be displayed
#'@param annot_col Name of the column to be displayed in the popups. Defaults to `"DATE"`.
#'
#'@return Creates a leaflet map of earthquake epicenters with annotation popups.
#'
#'@importFrom leaflet leaflet addTiles addCircleMarkers
#'@importFrom dplyr %>%
#'
#' @examples
#' \dontrun{
#' url<-"https://www.example-url.org"
#' ds <- eq_location_clean(eq_clean_data(ds))
#' ds %>%
#' dplyr::filter(COUNTRY %in% c("FRANCE","GERMANY","ITALY") & lubridate::year(DATE) >= 1980) %>%,
#' eq_map(annot_col = "DATE")
#'}
#'
#'@export
eq_map <- function(data, annot_col="DATE") {
    leaflet::leaflet() %>%
    leaflet::addTiles() %>%
    leaflet::addCircleMarkers(
            data = data,
            lng = ~LONGITUDE,
            lat = ~LATITUDE,
            radius = ~EQ_PRIMARY*2, # radius proportional to EQ magnitude
            popup = ~get(annot_col), # search column by name given to function
            stroke = FALSE,
            fillOpacity = 0.5)
    }




