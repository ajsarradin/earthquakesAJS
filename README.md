# earthquakesAJS

earthsquakesAJS provides several functions to read, clean, transform, and visualise earthquake data from NOAA's ["Significant Earthquake Database"](https://www.ngdc.noaa.gov/nndc/struts/form?t=101650&s=1&d=1) 
National Geophysical Data Center / World Data Service (NGDC/WDS): Significant Earthquake Database. National Geophysical Data Center, NOAA. doi:10.7289/V5TD9V7K.


## Installation

You can install the released version of earthquakesAJS from [github](https://github.com/) with:

```{r, eval=F}
devtools::install_github('ajsarradin/earthquakesAJS', build_vignettes = TRUE)
```

## Functions

earthsquakesAJS contains 3 functions to read and clean NOAA earthquake data:
* eq_read_data (loads data from an URL)
* eq_clean_data (cleans dates and coordinates)
* eq_location_clean (cleans location names)

earthquakesAJS further contains 4 functions to visualise and annotate NOAA earthquake data:
* geom_timeline (plots a timeline of earthquakes)
* geom_timeline_label (creates annotations for the timeline)
* eq_map (creats a leaflet map of earthquake locations)
* eq_create_label (adds more information to popups on the map)

## Examples

Download and clean the data from the NOAA website using the data's URL

```{r, eval=F}
url<-"https://www.ngdc.noaa.gov/nndc/struts/results?bt_0=&st_0=&type_17=EXACT&query_17=None+Selected&op_12=eq&v_12=&type_12=Or&query_14=None+Selected&type_3=Like&query_3=&st_1=&bt_2=&st_2=&bt_1=&bt_4=&st_4=&bt_5=&st_5=&bt_6=&st_6=&bt_7=&st_7=&bt_8=&st_8=&bt_9=&st_9=&bt_10=&st_10=&type_11=Exact&query_11=&type_16=Exact&query_16=&bt_18=&st_18=&ge_19=&le_19=&type_20=Like&query_20=&display_look=189&t=101650&s=1&submit_all=Search+Database"
ds<-eq_read_data(url)
ds<-eq_location_clean(eq_clean_data(ds)) 

```

Plot a timeline of earthquakes

```{r, eval=F}
aux<-dplyr::filter(ds, DATE >= "1980-01-01" & DATE <="2014-01-01" & COUNTRY == c("JAPAN","CHILE"))

ggplot2::ggplot(aux) +
    geom_timeline(ggplot2::aes(x=DATE, y=COUNTRY, size=EQ_MAG_MB, colour=DEATHS)) +
    viridis::scale_colour_viridis(option="D") +
    ggplot2::theme_minimal() 
```

Plot a timeline with labels

```{r, eval=F}
ggplot2::ggplot(aux) +
    geom_timeline(ggplot2::aes(x=DATE, y=COUNTRY, size=EQ_MAG_MB, colour=DEATHS)) +
    geom_timeline_label(ggplot2::aes(x=DATE, y=COUNTRY, label=LOCATION_NAME)) +
    viridis::scale_colour_viridis(option="D") +
    ggplot2::theme_minimal() 
```


Label only a subset of 3 earthquakes with the highest magnitude                             

```{r, eval=F}
ggplot2::ggplot(aux) +
    geom_timeline(ggplot2::aes(x=DATE, y=COUNTRY, size=EQ_MAG_MB, colour=DEATHS)) +
    geom_timeline_label(ggplot2::aes(x=DATE, y=COUNTRY, label=LOCATION_NAME, 
                                     n_max=3, max_aes=EQ_MAG_MB)) +
    viridis::scale_colour_viridis(option="D") +
    ggplot2::theme_minimal() 
```

Create a leaflet map of earthquake locations

```{r, eval=F}
eq_map(dplyr::filter(ds, COUNTRY %in% c("FRANCE","GERMANY","ITALY") & lubridate::year(DATE) >= 1980), annot_col = "DATE")
```

Create a leaflet map of earthquake locations with more information in the popups

```{r, eval=F}
dplyr::filter(ds, COUNTRY  %in% c("USA") & lubridate::year(DATE) >= 1960) %>%
    dplyr::mutate(popup_text = eq_create_label(.)) %>%
    eq_map(annot_col = "popup_text")
```





