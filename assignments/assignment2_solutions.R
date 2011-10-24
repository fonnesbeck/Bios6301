haart <- read.csv("haart1.csv")
# Convert dates
haart$last.visit <- as.Date(haart$last.visit, format="%m/%d/%y")
haart$init.date <- as.Date(haart$init.date, format="%m/%d/%y")
haart$date.death <- as.Date(haart$date.death, format="%m/%d/%y")

# Followup time
# No deaths
haart$followup <- as.integer(haart$last.visit - haart$init.date)
# Deaths
haart$followup[haart$death==1] <- as.integer(haart$date.death - haart$init.date)[haart$death==1]
# Truncate at 1 year
haart$followup[haart$followup>365] <- 365
# Loss to followup
haart$ltf <- haart$followup==365

# Create variable containing array of drugs
init.reg <- as.character(haart$init.reg)
haart$init.reg.list <- strsplit(init.reg, ",")
# Create unique list of drugs
all_drugs <- unique(unlist(haart$init.reg.list))
# Create matrix of drug membership
reg_drugs <- c()
for (drug in all_drugs) reg_drugs <- cbind(reg_drugs, sapply(haart$init.reg.list, function(x) drug %in% x))
# Turn into data frame
reg_drugs.df <- data.frame(reg_drugs)
# Use unique names as column headers
names(reg_drugs.df) <- all_drugs
# Merge with the rest of the data
haart_merged <- cbind(haart, reg_drugs.df)