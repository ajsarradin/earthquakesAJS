# test eq_read_data function
url<-"https://www.ngdc.noaa.gov/nndc/struts/results?bt_0=&st_0=&type_17=EXACT&query_17=None+Selected&op_12=eq&v_12=&type_12=Or&query_14=None+Selected&type_3=Like&query_3=&st_1=&bt_2=&st_2=&bt_1=&bt_4=&st_4=&bt_5=&st_5=&bt_6=&st_6=&bt_7=&st_7=&bt_8=&st_8=&bt_9=&st_9=&bt_10=&st_10=&type_11=Exact&query_11=&type_16=Exact&query_16=&bt_18=&st_18=&ge_19=&le_19=&type_20=Like&query_20=&display_look=189&t=101650&s=1&submit_all=Search+Database"
aux<-eq_read_data(url)

expect_that(aux, is_a('tbl_df'))




# test eq_clean_data function
ds<-eq_clean_data(aux)

expect_that(ds$DATE, is_a("Date"))
expect_that(ds$LATITUDE, is_a("numeric"))
expect_that(ds$LONGITUDE, is_a("numeric"))


# test geom_timeline function
aux<-dplyr::filter(ds, DATE >= "1980-01-01" & DATE <="2014-01-01" & COUNTRY == c("JAPAN","CHILE"))

expect_that(ggplot2::ggplot(aux) + geom_timeline(ggplot2::aes(x=DATE, y=COUNTRY, size=EQ_MAG_MB, colour=DEATHS)),
          is_a("ggplot"))


# test geom_timeline_label function
expect_that(ggplot2::ggplot(aux) +
                          geom_timeline(ggplot2::aes(x=DATE, y=COUNTRY, size=EQ_MAG_MB, colour=DEATHS)) +
                          geom_timeline_label(ggplot2::aes(x=DATE, y=COUNTRY, label=LOCATION_NAME)),
                      is_a("ggplot"))


# test eq_location_clean function
ds<-eq_location_clean(ds)

expect_that(ds$LOCATION_NAME, is_a("character"))


# test eq_map function
expect_that(eq_map(dplyr::filter(ds, COUNTRY %in% c("FRANCE","GERMANY","ITALY") & lubridate::year(DATE) >= 1980),
                             annot_col = "DATE"), is_a('leaflet'))


# test eq_create_label function
expect_that(eq_create_label(ds), is_a("character"))


# clean up after testing
rm(url)
rm(aux)
rm(ds)



