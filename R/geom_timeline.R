#'Draw a timeline of NOAA earthquake events
#'
#'Function that draws a timeline of earthquake events for one or more selected
#'countries. The timeline can optionally feature the magnitude and number of
#'victimes of earthquakes represented by points of different size and/or colour.
#'Function to be used in a \code{\link{ggplot}} call to NOAA earthquake data downloaded and cleaned with the
#'\code{\link{eq_read_data}} and \code{\link{eq_clean_data}} functions of the `earthquakesAJS`` package.
#'
#'@inheritParams ggplot2::layer
#'@param mapping Set of aesthetic mappings created
#'@param data Input data for timeline
#'@param stat The statistical transformation to use on the data
#'@param position Position adjustment, either as a string, or the result of a call to a position adjustment
#'function
#'@param na.rm If `FALSE`, the default, missing values are removed with a warning. If `TRUE`,
#'missing values are silently removed
#'@param show.legend Logical. Should this layer be included in the legends?
#'@param inherit.aes If `FALSE``, overrides the default aesthetics, rather than
#'  combining with them
#'@param ... Other arguments passed on to `[layer()]`. These are often aesthetics, used to set an aesthetic
#'to a fixed value, like `colour ="blue"`
#'
#'@return Draws a timeline of earthquake events for one or more selected
#'  countries
#'
#'@importFrom ggplot2 layer
#'
#' @examples
#' \dontrun{
#' url<-"https://www.ngdc.noaa.gov/nndc/struts/results?bt_0=&st_0=&type_17=EXACT&query_17=None+Selected&op_12=eq&v_12=&type_12=Or&query_14=None+Selected&type_3=Like&query_3=&st_1=&bt_2=&st_2=&bt_1=&bt_4=&st_4=&bt_5=&st_5=&bt_6=&st_6=&bt_7=&st_7=&bt_8=&st_8=&bt_9=&st_9=&bt_10=&st_10=&type_11=Exact&query_11=&type_16=Exact&query_16=&bt_18=&st_18=&ge_19=&le_19=&type_20=Like&query_20=&display_look=189&t=101650&s=1&submit_all=Search+Database
#' ds <- eq_location_clean(eq_clean_data(ds))
#' aux<-dplyr::filter(ds, DATE >= "1980-01-01" & DATE <="2014-01-01" & COUNTRY == c("JAPAN","CHILE"))
#' ggplot2::ggplot(aux) +
#' geom_timeline(ggplot2::aes(x=DATE, y=COUNTRY, size=EQ_MAG_MB, colour=DEATHS)) +
#' viridis::scale_colour_viridis(option="D") +
#' ggplot2::theme_minimal()
#'}
#'
#'@export
geom_timeline <- function(mapping = NULL, data = NULL, stat = "identity", position = "identity", na.rm = FALSE,
                          show.legend = NA, inherit.aes = TRUE, ...) {
    ggplot2::layer(
        stat = stat,
        geom = GeomTimeline,
        data = data,
        mapping = mapping,
        position = position,
        show.legend = show.legend,
        inherit.aes = inherit.aes,
        params = list(na.rm = na.rm, ...)
        )
    }



#' Timeline object for the geom_timeline function.
#'
#' \code{ggproto} object underlying the \code{\link{geom_timeline}} function of the `earthquakesAJS`` package.
#'
#'@importFrom ggplot2 aes ggproto Geom draw_key_point alpha .pt
#'@importFrom grid gpar segmentsGrob pointsGrob gList gTree
#'
GeomTimeline <- ggplot2::ggproto(
    "GeomTimeline",
    ggplot2::Geom,
    required_aes= c("x"),
    default_aes = ggplot2::aes(
        y=NA,
        colour = NA,
        fill = NA,
        size = 1,
        alpha = 0.7,
        shape=19, # needed
        stroke = 0.5 # needed
        ),
    # draws the key for the legend
    draw_key = ggplot2::draw_key_point,
    # returns a grid grob
    draw_panel = function(data, panel_params, coord){
        # transform the data
        coords <- coord$transform(data, panel_params)
        # define axis on which points will be plotted (using grid)
        timeline <- grid::segmentsGrob(
            x0 = min(coords$x),
            x1 = max(coords$x),
            y0 = coords$y,
            y1 = coords$y,
            gp = grid::gpar(col = ggplot2::alpha(coords$colour, coords$alpha))
            )
        # defnine points to plot (using grid)
        earthquake <-grid::pointsGrob(
            x = coords$x,
            y = coords$y,
            pch = coords$shape,
            gp = grid::gpar(
                col = ggplot2::alpha(coords$colour, coords$alpha),
                fill = ggplot2::alpha(coords$fill, coords$alpha),
                lwd = coords$size*ggplot2::.pt
                ) # compare with default aes above
            )
        # draw both axis and points
        grid::gTree(children = grid::gList(timeline, earthquake))
        }
    )



