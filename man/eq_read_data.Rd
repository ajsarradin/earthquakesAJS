% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/eq_read_tidy.R
\name{eq_read_data}
\alias{eq_read_data}
\title{Read NOAA earthquake data and perform rudimentary cleaning}
\usage{
eq_read_data(url)
}
\arguments{
\item{url}{A URL link to the data to be downloaded}
}
\value{
Returns the selected file as a tbl_df table, or an error if the
file does not exists. Default classes are defined for all columns of the table
}
\description{
Function that reads a file from the National Geophysical Data Center
World Data Service (NGDC/WDS): Significant Earthquake Database and converts it into a \code{tbl_df} table.
Takes a URL link to the database as input.
}
\examples{
\dontrun{
url<-"https://www.example-url.org"
eq_read_data(url)
}

}
