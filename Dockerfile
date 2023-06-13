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

# Copy the r_packages.txt file to the image working directory
COPY r_packages.txt /

# Install system dependencies for the specified R packages
RUN R_PACKAGES=$(cat r_packages.txt) && \
    Rscript -e 'args <- strsplit(Sys.getenv("R_PACKAGES"), "\n", fixed = TRUE)[[1]]; args <- subset(args, args != ""); writeLines(remotes::system_requirements("ubuntu", "18.04", package = args))' | \
    while read -r cmd; do \
    echo $cmd && eval sudo $cmd; \
    done

# Continue with other steps to install and configure the specified R packages

# For example:
# RUN R -e 'remotes::install_cran(c("nanonext", "devtools", "tidyverse"))'

# Set the entry point or command if required
# ENTRYPOINT ["R"]
