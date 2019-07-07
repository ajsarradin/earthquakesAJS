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
#' url<-"https://www.ngdc.noaa.gov/nndc/struts/results?bt_0=&st_0=&type_17=EXACT&query_17=None+Selected&op_12=eq&v_12=&type_12=Or&query_14=None+Selected&type_3=Like&query_3=&st_1=&bt_2=&st_2=&bt_1=&bt_4=&st_4=&bt_5=&st_5=&bt_6=&st_6=&bt_7=&st_7=&bt_8=&st_8=&bt_9=&st_9=&bt_10=&st_10=&type_11=Exact&query_11=&type_16=Exact&query_16=&bt_18=&st_18=&ge_19=&le_19=&type_20=Like&query_20=&display_look=189&t=101650&s=1&submit_all=Search+Database
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








