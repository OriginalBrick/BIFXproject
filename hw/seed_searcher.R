# J Jedediah Smith
# BIFX 552
# Find a seed that when you use the random number function generates 10 heads in a row.

# Generate random seeds to test
library(magrittr)
TestSet <- runif(1000,1,1e6) %>%
  round()

# Create starting values
i <- 1
SavedStr <- c("884463", "958181", "691709", "231632", "190714") #These are seeds I already found.
ncheck <- "10" # Number of places to check.
nheads <- numeric(length(TestSet)) # List for number of heads found each time.

# Loop to test each random seed
for(i in 1:length(TestSet))
{
  # Set seed to each index in TestSet
  set.seed(TestSet[i])
  
  # Generate first 10 numbers
  CurrentStr <- rbinom(10,1,0.5)
  
  # Get their sum and record the number of heads
  CurrentSum <- sum(CurrentStr)
  nheads[i] <- CurrentSum
  
  # When sum = 10, save the index.
  if (sum(CurrentStr)<10) {
    print("Failure")
  } else {
    print("Success")
    SavedStr <- append(save, TestSet[i])
    break
  }
}