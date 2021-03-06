# Copyright (c) 2018, Boise State University All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

library("RCurl")
library("rjson")

# API documentation:
#
# https://forecast-v3.weather.gov/documentation

# REQUEST OMIT
# Scheme for the api.  Other schemes include 'http', 'ftp', etc.
scheme <- "https"
# Host of the API service.
host <- "api.weather.gov"
# Latitude of the forecast point.
lat <- 43.5670
# Longitude of the forecast point.
lon <- -116.2405

# The API limits the resolution of points to 4 decimal points.
pointPath <- sprintf("/points/%.4f,%.4f/forecast", lat, lon)

# The fully qualified URL
apiURL <- sprintf("%s://%s%s", scheme, host, pointPath)

# REQUEST OMIT

print(apiURL)

# CURL OMIT
# The actual API call redirects to a gridpoint API, so we'll follow redirects.
redirect = TRUE

# The weather.gov API requires a User-Agent to be set to allow access.  Set that
# header value, as well as explicitly set the format.
hdr <- c("Accept:application/geo+json", "User-Agent:BSU/RUG")

# Download the resource at apiURL
data <- getURL(apiURL, httpheader=hdr, followlocation=redirect)
# CURL OMIT

# DECODE OMIT
# The data is returned in JSON (actually GeoJSON), so we need to unmarshal it.
x <- fromJSON(data)

# Print out the forecast temperature in human readable form.
for(p in x$properties$periods) {
  print(sprintf("%s: %d°F", p$name, p$temperature))
}

# DECODE OMIT

