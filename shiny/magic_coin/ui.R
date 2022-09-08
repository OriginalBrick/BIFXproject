#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Magic Coin"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            numericInput("seed.start",
                         "Starting seed:",
                         min = 1,
                         max = .Machine$integer.max,
                         value = round(runif(1) * 1e5)),
            textOutput("best.seed")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("successHistory"),
            actionButton('add1', 'Check 10 seeds'),
            actionButton('add2', 'Check 100 seeds'),
            actionButton('add3', 'Check 1000 seeds')
        )
    )
))
