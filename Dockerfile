FROM rocker/shiny:4.2.2

# RUN apt-get update
# RUN apt-get install -y libgdal-dev libgeos-dev libproj-dev libudunits2-dev

RUN Rscript -e 'install.packages("dplyr")'

# RUN rm -rf /tmp/*
# RUN rm -rf /var/lib/apt/lists/*
# RUN strip /usr/local/lib/R/site-library/*/libs/*.so

COPY apps /srv/apps/
COPY shiny-server.conf /etc/shiny-server/
