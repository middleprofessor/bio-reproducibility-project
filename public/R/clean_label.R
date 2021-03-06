# function to remove spaces and units from column labels
# Jeff Walker
# November 12, 2018
# to use, add "source("clean_label.R")"


clean_label <- function(x){
  # clean units in parentheses and units with space in front of parenthesis
  x <- gsub(" \\s*\\([^\\)]+\\)","", x)
  # clean units in parentheses and units without space in front of parenthesis
  x <- gsub("\\s*\\([^\\)]+\\)","", x)

  #remove spaces
  x <- gsub(" ", "_", x)

  # replace hash with "n"
  x <- gsub("#", "n_", x)

  # replace % with "perc"
  x <- gsub("%", "perc_", x)

  # get rid of any double "__"
  x <- gsub("__", "_", x)

  # replace hyphens
  x <- gsub("-", "_", x)

  # replace forward slash
  x <- gsub("/_", ".", x)

  # replace forward slash
  x <- gsub("/", ".", x)
  
  return(x)
}
