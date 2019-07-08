#'Add location labels to a NOAA earthquake timeline
#'
#'Function that adds labels with the location of earthquake events to a timeline created with the
#'\code{\link{geom_timeline}} function of the `earthquakesAJS`` package.
#'The function has two optional parameter `n_max` and `max_aes`` to limit labels to a subset of
#'earthquakes with the `n_max` largest values on the `max_aes`` variable.
#'Function to be used in a \code{\link{ggplot}} call to NOAA earthquake data downloaded and cleaned with the
#'\code{\link{eq_read_data}} and \code{\link{eq_clean_data}} functions of the `earthquakesAJS`` package.
#'
#'@inheritParams ggplot2::layer
#'@param mapping Set of aesthetic mappings created
#'@param data Input data for timeline
#'@param stat The statistical transformation to use on the data
#'@param position Position adjustment, either as a string, or the result of a call to a position
#'adjustment function.
#'@param na.rm If `FALSE`, the default, missing values are removed with a warning. If `TRUE`,
#'missing values are silently removed
#'@param show.legend Logical. Should this layer be included in the legends?
#'@param inherit.aes If `FALSE``, overrides the default aesthetics, rather than combining with them
#'@param ... Other arguments passed on to `[layer()]`. These are often
#'aesthetics, used to set an aesthetic to a fixed value, like `colour ="blue"`
#'
#'@return Draws a timeline of earthquake events for one or more selected
#'  countries
#'
#'@importFrom ggplot2 layer
#'
#' @examples
#' \dontrun{
#' url<-"https://www.example-url.org"
#' ds <- eq_location_clean(eq_clean_data(ds))
#' aux<-dplyr::filter(ds, DATE >= "1980-01-01" & DATE <="2014-01-01" & COUNTRY == c("JAPAN","CHILE"))
#' ggplot2::ggplot(aux) +
#' geom_timeline(ggplot2::aes(x=DATE, y=COUNTRY, size=EQ_MAG_MB, colour=DEATHS)) +
#' geom_timeline_label(ggplot2::aes(x=DATE,y=COUNTRY,label=LOCATION_NAME,n_max=3,max_aes=EQ_MAG_MB)) +
#' viridis::scale_colour_viridis(option="D") +
#' ggplot2::theme_minimal()
#'}
#'
#'@export
geom_timeline_label <- function(mapping = NULL, data = NULL, stat = "identity", position = "identity", na.rm = FALSE,
                                show.legend = NA, inherit.aes = TRUE, ...) {
    ggplot2::layer(
        stat = stat,
        geom = GeomTimelineLabel,
        data = data,
        mapping = mapping,
        position = position,
        show.legend = show.legend,
        inherit.aes = inherit.aes,
        params = list(na.rm = na.rm, ...)
        )
    }



#' Timeline label object for the geom_timeline_label function.
#'
#' \code{ggproto} object underlying the \code{\link{geom_timeline_label}} function of the `earthquakesAJS` package.
#'
#'@importFrom ggplot2 aes ggproto Geom draw_key_point alpha .pt
#'@importFrom grid gpar segmentsGrob textGrob gList gTree
#'@importFrom dplyr slice arrange group_by
GeomTimelineLabel <- ggplot2::ggproto(
    "GeomTimelineLabel",
    ggplot2::Geom,
    required_aes=c("x","label"),
    default_aes=ggplot2::aes(y=0,
                             n_max=0,
                             max_aes=NULL),
    # returns a grid grob
    draw_panel=function(data,panel_params,coord){

        # filter data if requested
        if (data$n_max[1]>0){
            if (data$y[1]==0){
                data <- dplyr::slice(dplyr::arrange(data, desc(data$max_aes)), 1:data$n_max[1])
            }
            else {
                data <- dplyr::slice(dplyr::arrange(dplyr::group_by(data,y), desc(data$max_aes)), 1:data$n_max[1])
            }
        }

        # transform the data
        coords <- coord$transform(data, panel_params)
        # defnine lines connecting labels to axis
        label_segments<-grid::segmentsGrob(
            x0 = coords$x,
            y0 = coords$y,
            x1 = coords$x,
            y1 = coords$y,
            gp = grid::gpar(col = "black", lwd = .5)
            )
        # define labels
        labels<-grid::textGrob(
            label = coords$label,
            x = coords$x,
            y = coords$y ,
            just = "left",
            rot = 35,
            gp = grid::gpar(fontsize=10)
            )
        # draw both labels and label segments
        grid::gTree(children = grid::gList(label_segments, labels))
        }
    )



