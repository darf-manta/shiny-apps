FROM rocker/shiny:4.5.0

RUN apt-get update
RUN apt-get install -y libgdal-dev libgeos-dev libproj-dev libudunits2-dev

RUN Rscript -e 'install.packages("sf")'
RUN Rscript -e 'install.packages("dplyr")'
RUN Rscript -e 'install.packages("exifr")'

# RUN rm -rf /tmp/*
# RUN rm -rf /var/lib/apt/lists/*
# RUN strip /usr/local/lib/R/site-library/*/libs/*.so

COPY R         /home/shiny/R/
COPY apps      /home/shiny/apps/
COPY data      /home/shiny/data/
COPY static    /home/shiny/static/
COPY .Rprofile /home/shiny/
COPY shiny-server.conf /etc/shiny-server/
