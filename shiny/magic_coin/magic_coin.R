#' magic_coin
#' 
#' function to look for a random seed that results in as many successes in a row as possible when running the command, `rbinom(50, 1, 0.5)`. 
#' 
#' @param seeds A vector of random seeds to test
#' @param input List of seeds that have been tested - names are seeds, values are the number of successes in a row
#' 
#' @return An updated list combining `input` with results from `seed`
magic_coin <- function(seeds, input = list())
{
    # check for up to 100 heads in a row (it is unlikely that we'll find 100)
    ncheck <- 100
    
    #...
    
    bind_rows(input,
              tibble(nheads = nheads,
                     seed = seeds)) %>%
        return()
}
