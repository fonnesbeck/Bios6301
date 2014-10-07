load('../datasets/rxlist.RData')

trim <- function(x) gsub('^\\s+|\\s+$', '', x)

# require dataframe with rx column
parseDrugs <- function(x) {
  x <- data.frame(rx=x)
  newVars <- c('tech','brand','dosage','paran','with','injection','infusion','oral','suppository','nasal')
  x[,newVars] <- ''
  x$tech <- toupper(sub("[:].*$", '', x$rx))

  x$injection <- grepl("INJ", x$tech)
  # may not want to remove INJ string
  x$tech[x$injection] <- sub('[ ]*(INJ|INJECTION)', '', x$tech[x$injection])

  # check for infusion
  x$infusion <- grepl("INFUSION", x$tech)
  x$tech[x$infusion] <- sub('REGULAR INFUSION|INFUSION', '', x$tech[x$infusion])

  # taken with additional drug
  haswith <- grep("W/|WITH", x$tech)
  x$with[haswith] <- trim(sub('.*(W/|WITH)(.*)$', '\\2', x$tech[haswith]))
  x$tech[haswith] <- sub('[ ]*(W/|WITH).*$', '', x$tech[haswith])

  # brand name follows colon
  x$brand <- toupper(trim(sub("^[^:]*[:]*(.*)$", '\\1', x$rx)))

  # paranthetical notes
  x$paran <- trim(sub('^[^(]*[(]*([^)]*)[)]*$', '\\1', x$tech))
  x$tech <- sub('[ ]*[(].*$', '', x$tech)

  # dose info
  x$dosage <- trim(sub("^[^0-9]*([0-9]*.*)$", "\\1", x$tech))
  x$tech <- sub('[ ]*[0-9]+.*$', '', x$tech)

  # additional might follow /
  hasmore <- which(grepl("^[^/]*[/]+", x$tech) & x$with == '')
  if(length(hasmore)) {
    x$with[hasmore] <- toupper(trim(sub("^[^/]*[/]*(.*)$", '\\1', x$tech[hasmore])))
    x$tech[hasmore] <- sub("[ ]*[/]+(.*)$", '', x$tech[hasmore])
  }

  # oral meds
  isoral <- grep("[ ](ORAL|CHEWABLE)", x$tech)
  x$oral[isoral] <- trim(sub('.*[ ]((ORAL|CHEWABLE).*)$', '\\1', x$tech[isoral]))
  x$tech[isoral] <- sub('[ ](ORAL|CHEWABLE).*$', '', x$tech[isoral])

  # suppository meds
  x$suppository <- grepl("SUPPOSITORY", x$tech)
  x$tech[x$suppository] <- sub('[ ]SUPPOSITORY.*$', '', x$tech[x$suppository])

  # naval meds
  x$nasal <- grepl("NASAL", x$tech)
  x$tech[x$nasal] <- sub('[ ]NASAL.*$', '', x$tech[x$nasal])

  # if technical name is missing, use dosage
  doseToTech <- which(x$tech == '' & x$dosage != '')
  x$tech[doseToTech] <- x$dosage[doseToTech]
  x$dosage[doseToTech] <- ''
  x$tech <- sub('[-; ]*$', '', trim(x$tech))

  # might want to do this
  # x <- x[order(x$tech, x$dosage),]
  print(apply(x[,newVars],MARGIN=2,function(i) length(unique(i))))
  x
}

x <- parseDrugs(rx)
