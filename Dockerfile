FROM rocker/verse:4.0.0-ubuntu18.04

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    && add-apt-repository ppa:marutter/rrutter4.0 \
    && apt-get update && apt-get install -y --no-install-recommends \
    libxml2-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libmariadbclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Install remotes R package
RUN R -e 'install.packages("remotes", repos = "https://cloud.r-project.org")'

# Define the R packages vector
ARG R_PACKAGES="bs4Dash
clustermq
crew
dplyr
flextable
future
gt
gtsummary
knitr
markdown
mirai
nanonext
devtools
igraph
pingr
rstudioapi
shiny
shinybusy
shinyWidgets
targets
tarchetypes
tidyverse
visNetwork
workflowr"

# Install system dependencies for the specified R packages
RUN Rscript -e 'args <- commandArgs(trailingOnly = TRUE); writeLines(remotes::system_requirements("ubuntu", "20.04", package = strsplit(args, "\n", fixed = TRUE)[[1]]))' "$R_PACKAGES" | \
    while read -r cmd; do \
    eval sudo $cmd; \
    done

# Continue with other steps to install and configure the specified R packages

# For example:
# RUN R -e 'remotes::install_cran(c("nanonext", "devtools", "tidyverse"))'

# Set the entry point or command if required
# ENTRYPOINT ["R"]
