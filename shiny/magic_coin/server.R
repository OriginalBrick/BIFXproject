#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(cowplot)
theme_cowplot() %>%
    theme_set()

source('magic_coin.R')

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    # keep track of each trial we've performed
    trials <- reactiveVal(tibble(nheads = numeric(), seed = integer()))
    
    # plot all of our results so far
    # y-axis: number of heads
    # x-axis: number of trials
    output$successHistory <- renderPlot({
        
        tmp <- trials()
        
        # calculate running-best-value
        tmp$nmax <- tmp$nheads[1]

        for(i in 2:nrow(tmp))
        {
            if(tmp$nheads[i] > tmp$nmax[i-1])
            {
                tmp$nmax[i] <- tmp$nheads[i]
            }else{
                tmp$nmax[i] <- tmp$nmax[i - 1]
            }
        }
        
        # generate figure
        # ...
    })
    
    # display the best seed so far
    output$best.seed <- renderText({
        if(nrow(trials()) > 0)
        {
            best <- which.max(trials()$nheads)
        
            mssg <- paste('The best seed so far is', 
                  trials()$seed[best],
                  'which results in',
                  trials()$nheads[best],
                  'successes in a row.')
        }else{
            mssg <- 'Add some trials'
        }
        
        mssg
    })
    
    # Buttons to do additional trials
    observeEvent(input$add1, {
        trials(magic_coin(as.integer(runif(10, 1, .Machine$integer.max)), trials()))
    })

    observeEvent(input$add2, {
        # ...
    })
    observeEvent(input$add3, {
        # ...
    })
})
