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
#' url<-"https://www.ngdc.noaa.gov/nndc/struts/results?bt_0=&st_0=&type_17=EXACT&query_17=None+Selected&op_12=eq&v_12=&type_12=Or&query_14=None+Selected&type_3=Like&query_3=&st_1=&bt_2=&st_2=&bt_1=&bt_4=&st_4=&bt_5=&st_5=&bt_6=&st_6=&bt_7=&st_7=&bt_8=&st_8=&bt_9=&st_9=&bt_10=&st_10=&type_11=Exact&query_11=&type_16=Exact&query_16=&bt_18=&st_18=&ge_19=&le_19=&type_20=Like&query_20=&display_look=189&t=101650&s=1&submit_all=Search+Database
#' ds <- eq_location_clean(eq_clean_data(ds))
#'eq_map(dplyr::filter(ds, COUNTRY %in% c("FRANCE","GERMANY","ITALY") & lubridate::year(DATE) >= 1980),
#'annot_col = "DATE")
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




