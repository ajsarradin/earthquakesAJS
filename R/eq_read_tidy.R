#' Read NOAA earthquake data and perform rudimentary cleaning
#'
#' Function that reads a file from the National Geophysical Data Center
#' World Data Service (NGDC/WDS): Significant Earthquake Database and converts it into a \code{tbl_df} table.
#' Takes a URL link to the database as input.
#'
#' @param url A URL link to the data to be downloaded
#'
#' @return Returns the selected file as a tbl_df table, or an error if the
#' file does not exists. Default classes are defined for all columns of the table
#'
#' @importFrom readr read_delim cols col_character col_double
#' @importFrom dplyr mutate
#'
#' @examples
#' \dontrun{
#' url<-"https://www.ngdc.noaa.gov/nndc/struts/results?bt_0=&st_0=&type_17=EXACT&query_17=None+Selected&op_12=eq&v_12=&type_12=Or&query_14=None+Selected&type_3=Like&query_3=&st_1=&bt_2=&st_2=&bt_1=&bt_4=&st_4=&bt_5=&st_5=&bt_6=&st_6=&bt_7=&st_7=&bt_8=&st_8=&bt_9=&st_9=&bt_10=&st_10=&type_11=Exact&query_11=&type_16=Exact&query_16=&bt_18=&st_18=&ge_19=&le_19=&type_20=Like&query_20=&display_look=189&t=101650&s=1&submit_all=Search+Database
#' eq_read_data(url)
#' }
#'
#' @export
eq_read_data <- function(url) {
    # check if URL exists
    if(!RCurl::url.exists(url))
        stop("url '", url,"' does not exist")
    # read in data & define column classes for those variables that were firt read in as logical
    ds<-readr::read_delim(url, delim="\t",
        col_types = readr::cols(
                          SECOND = readr::col_character(),
                          EQ_MAG_MB = readr::col_character(),
                          EQ_MAG_MFA = readr::col_character(),
                          MISSING = readr::col_double(),
                          DAMAGE_MILLIONS_DOLLARS = readr::col_character(),
                          TOTAL_DAMAGE_MILLIONS_DOLLARS = readr::col_character(),
                          TOTAL_MISSING = readr::col_double(),
                          TOTAL_MISSING_DESCRIPTION = readr::col_double()
                          )
        )
    # convert de facto numeric columns (some screening was necessary to find out which ones)
    ds<-dplyr::mutate(ds,
        DEATHS=as.numeric(DEATHS),
        TOTAL_DEATHS=as.numeric(TOTAL_DEATHS),
        SECOND=as.numeric(SECOND),
        EQ_PRIMARY=as.numeric(EQ_PRIMARY),
        EQ_MAG_MW=as.numeric(EQ_MAG_MW),
        EQ_MAG_MS=as.numeric(EQ_MAG_MS),
        EQ_MAG_MB=as.numeric(EQ_MAG_MB),
        EQ_MAG_MFA=as.numeric(EQ_MAG_MFA),
        EQ_MAG_UNK=as.numeric(EQ_MAG_UNK),
        DAMAGE_MILLIONS_DOLLARS=as.numeric(DAMAGE_MILLIONS_DOLLARS),
        TOTAL_DAMAGE_MILLIONS_DOLLARS=as.numeric(TOTAL_DAMAGE_MILLIONS_DOLLARS)
        )
    # return clean dataset
    return(ds)
    }



#' Reformat date & coordinates of NOAA earthquake data
#'
#' Function that reformats date & coordinates of NOAA earthquake data.
#'
#' @param data A table downloaded with the \code{\link{eq_read_data}} function from the `earthquakesAJS`` package
#'
#' @return Returns a table with a "DATE" column of the Date class that indicates year, month and day of
#' an earthquake occurence. Also converts "LONGITUDE" and "LATITUDE" columns to numeric class
#'
#' @importFrom lubridate years ymd
#' @importFrom dplyr mutate
#'
#' @examples
#' \dontrun{
#' url<-"https://www.ngdc.noaa.gov/nndc/struts/results?bt_0=&st_0=&type_17=EXACT&query_17=None+Selected&op_12=eq&v_12=&type_12=Or&query_14=None+Selected&type_3=Like&query_3=&st_1=&bt_2=&st_2=&bt_1=&bt_4=&st_4=&bt_5=&st_5=&bt_6=&st_6=&bt_7=&st_7=&bt_8=&st_8=&bt_9=&st_9=&bt_10=&st_10=&type_11=Exact&query_11=&type_16=Exact&query_16=&bt_18=&st_18=&ge_19=&le_19=&type_20=Like&query_20=&display_look=189&t=101650&s=1&submit_all=Search+Database
#' data<-eq_read_data(url)
#' data<-eq_clean_data(data)
#' }
#'
#' @export
eq_clean_data <- function(data) {
    ds<-dplyr::mutate(data, DATE=paste("0000",MONTH,DAY,sep="-"))
    ds<-dplyr::mutate(ds,LATITUDE= as.numeric(LATITUDE))
    ds<-dplyr::mutate(ds,LONGITUDE= as.numeric(LONGITUDE))
    ds<-dplyr::mutate(ds,DATE=lubridate::ymd(as.Date(DATE,"%Y-%m-%d"))+lubridate::years(YEAR)) # trick for BC dates
    ds
    }



#' Reformat location names in NOAA earthquake data
#'
#' Function that reformats location names in NOAA earthquake data.
#'
#' @param data A table downloaded with the \code{\link{eq_read_data}) function from the `earthquakesAJS` package
#'
#' @return Returns a table with a cleaned "LOCATION_NAME" column where the country name has been stripped
#' and location names have been converted to title case
#'
#' @importFrom stringr str_to_title
#' @importFrom dplyr mutate
#'
#' @examples
#' \dontrun{
#' url<-"https://www.ngdc.noaa.gov/nndc/struts/results?bt_0=&st_0=&type_17=EXACT&query_17=None+Selected&op_12=eq&v_12=&type_12=Or&query_14=None+Selected&type_3=Like&query_3=&st_1=&bt_2=&st_2=&bt_1=&bt_4=&st_4=&bt_5=&st_5=&bt_6=&st_6=&bt_7=&st_7=&bt_8=&st_8=&bt_9=&st_9=&bt_10=&st_10=&type_11=Exact&query_11=&type_16=Exact&query_16=&bt_18=&st_18=&ge_19=&le_19=&type_20=Like&query_20=&display_look=189&t=101650&s=1&submit_all=Search+Database
#' data<-eq_read_data(url)
#' data<-eq_location_clean(data)
#'}
#'
# reformats location name
eq_location_clean <- function(data) {
    ds<-dplyr::mutate(data, LOCATION_NAME=gsub(".*:\\s*","",LOCATION_NAME)) # removing country name
    ds<-dplyr::mutate(ds,LOCATION_NAME=stringr::str_to_title(LOCATION_NAME))
    ds
    }








