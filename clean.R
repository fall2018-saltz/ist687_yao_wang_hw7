
##################################################################
# Use this block comment at the top of each R code file you submit
# Homework 7 – Submitted by Yao Wang on October 17, 2018
# Portions of this code came from Introduction to Data Science
# but the comments are all original.
# IST 687. Due is October 18, 2018

# step A: load and merge datasets
# re-use the code from HW3
readStates <- function()
{
  states <- raw_data
  # Read form from outside of R. Create a new dataframe "dfStates", then reserve the form into "dfStates"
  # remover rows that not needed 
  # -- first row is the total for the US, we do not need that 
  states <- states[-1,]
  #-- last row is Puerto Rico, it is not a states
  num.row <- nrow(states)
  states <- states[-num.row,]
  
  # remover the first for coclumns
  states <- states[,-1:-4]
  rownames(states) <- c(1:51) 
  # change names for remaining coclumns
  colnames(states) <- c("stateName", "population","popOver18", "percentOver18")
  
  # return the results
  return(states)
}

states <- readStates()  
str(states)
# 2. re-use the code from HW2
arrests <- USArrests 
str(arrests)
# create a column with "stateName", then can merage with the other dataframe "states"
arrests <- cbind("stateName" =row.names(arrests), arrests)

# 3. Create a merged dataframe
Newarrests <- merge(arrests, states, by=c("stateName"))
