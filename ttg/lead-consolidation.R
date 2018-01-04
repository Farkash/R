# consolidate lead files for TTG
# Steve Farkas

library(dplyr)

# Association of Christian Schools International
acsi <- read.csv("/Users/Steve/Dropbox/programming/Python/web-scraping/data/shared/acsi.csv", header = T)
# Association of Gospel Rescue Missions
agrm <- read.csv("/Users/Steve/Dropbox/programming/Python/web-scraping/data/shared/agrm.csv", header = T)
# Evangelical Council for Financial Accountability
ecfa <- read.csv("/Users/Steve/Dropbox/programming/Python/web-scraping/data/shared/ecfa.csv", header = T)
# Private School Review
psr <- read.csv("/Users/Steve/Dropbox/programming/Python/web-scraping/data/shared/private-school-review.csv", header = T)

names(acsi)
names(agrm)
names(ecfa)
names(psr)

# conform the names before combining:
# give an organization type to each data set
acsi$organization_type <- 'School'
acsi$lead_source <- "ACSI - Association of Christian Schools International"
acsi$lead_source_website <- 'https://www.acsi.org/'
agrm$organization_type <- 'Rescue Mission'
agrm$lead_source <- 'AGRM - Association of Gospel Rescue Missions'
agrm$lead_source_website <- 'http://www.agrm.org/agrm/default.asp'
ecfa$organization_type <- 'Ministry'
ecfa$lead_source <- 'ECFA - Evangelical Council for Financial Accountability'
ecfa$lead_source_website <- 'http://www.ecfa.org/'
psr$organization_type <- 'School'
psr$lead_source <- 'Private School Review'
psr$lead_source_website <- 'https://www.privateschoolreview.com/'

names(acsi) <- tolower(gsub('.', '_', names(acsi), fixed = TRUE))
names(acsi)[names(acsi) == "school_name"] <- "organization_name"
names(acsi)[names(acsi) == 'school_website'] <- "organization_website"
acsi$state_long <- NA
names(acsi)[names(acsi) == 'primary_contact_email'] <- 'email_address'

names(agrm) <- tolower(gsub('.', '_', names(agrm), fixed = TRUE))
names(agrm)[names(agrm) == 'organization'] <- 'organization_name'
names(agrm)[names(agrm) == 'website'] <- 'organization_website'
names(agrm)[names(agrm) == 'state'] <- 'state_long'
agrm$state <- NA

names(ecfa) <- tolower(gsub('.', '_', names(ecfa), fixed = TRUE))
names(ecfa)[names(ecfa) == 'name_of_organization'] <- 'organization_name'
names(ecfa)[names(ecfa) == 'website'] <- 'organization_website'
ecfa$state_long <- NA

names(psr) <- tolower(gsub('.', '_', names(psr), fixed = TRUE))
names(psr)[names(psr) == 'state_full'] <- 'state_long'
names(psr)[names(psr) == 'school_name'] <- 'organization_name'
names(psr)[names(psr) == 'website'] <- 'organization_website'


# make master list of all names
all_names <- c(names(acsi), names(agrm), names(ecfa), names(psr))
sort(all_names)
all_names <- sort(unique(all_names))

# how do I add multiple new columns to a frame?
# acsi[new_names] <- NA

# make character vector for each data set of names that are not already in it
acsi_names_not <- setdiff(all_names, names(acsi))
acsi[acsi_names_not] <- NA

agrm_names_not <- setdiff(all_names, names(agrm))
agrm[agrm_names_not] <- NA

ecfa_names_not <- setdiff(all_names, names(ecfa))
ecfa[ecfa_names_not] <- NA

psr_names_not <- setdiff(all_names, names(psr)) 
psr[psr_names_not] <- NA

# add all these names to each data set so they all have the same names, regardless of order




# how to order columns:
# start with the most important univeral columns, then add those from the best data sources
names_order <- c('organization_name', 'organization_type', 'email_address', 'phone_number', 
                 'fax_number', 'primary_contact_name', 'street_address', 'city', 'state', 
                 'zip_code', 'county', 'state_long', 'year_founded', 'organization_website',
                 
                 
                  'lead_source', 'lead_source_website')


# reorder them so they're all in the same order

# bind them together into one master set







