# BIFX 552 Class Project Dockerfile
# https://github.com/bifx552-22/BIFXproject

# build image in this directory with `docker build -t bifxproject .`
# run image with `docker run --user shiny --rm -p 3838:3838 -t bifxproject`

# start with shiny server and R
FROM rocker/shiny:4.2.1

# install shiny app
RUN rm -r /srv/shiny-server/*
COPY shiny/ /srv/shiny-server/

# run app
CMD ["/usr/bin/shiny-server"]