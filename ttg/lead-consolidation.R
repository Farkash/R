# consolidate lead files for TTG
# Steve Farkas

library(dplyr)
library(data.table)

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
acsi$acsi_page <- NULL # drop this field, not valuable

names(agrm) <- tolower(gsub('.', '_', names(agrm), fixed = TRUE))
names(agrm)[names(agrm) == 'organization'] <- 'organization_name'
names(agrm)[names(agrm) == 'website'] <- 'organization_website'
names(agrm)[names(agrm) == 'state'] <- 'state_long'
agrm$state <- NA

names(ecfa) <- tolower(gsub('.', '_', names(ecfa), fixed = TRUE))
names(ecfa)[names(ecfa) == 'name_of_organization'] <- 'organization_name'
names(ecfa)[names(ecfa) == 'website'] <- 'organization_website'
names(ecfa)[names(ecfa) == 'membership_type'] <- 'ecfa_membership_type'
ecfa$state_long <- NA

names(psr) <- tolower(gsub('.', '_', names(psr), fixed = TRUE))
names(psr)[names(psr) == 'state_full'] <- 'state_long'
names(psr)[names(psr) == 'school_name'] <- 'organization_name'
names(psr)[names(psr) == 'website'] <- 'organization_website'

acsi_names_frame <- cbind(source = 'acsi', colname = names(acsi))
agrm_names_frame <- cbind(source = 'agrm', colname = names(agrm))
ecfa_names_frame <- cbind(source = 'ecfa', colname = names(ecfa))
psr_names_frame <- cbind(source = 'psr', colname = names(psr))

# make master list of all names
all_names <- c(names(psr), names(acsi), names(ecfa), names(agrm))
all_names <- unique(all_names)

# make character vector of names that are not already in each data set
# then add all these names to each data set so they all have the same names, regardless of order
acsi_names_not <- setdiff(all_names, names(acsi))
acsi[acsi_names_not] <- NA

agrm_names_not <- setdiff(all_names, names(agrm))
agrm[agrm_names_not] <- NA

ecfa_names_not <- setdiff(all_names, names(ecfa))
ecfa[ecfa_names_not] <- NA

psr_names_not <- setdiff(all_names, names(psr)) 
psr[psr_names_not] <- NA

# how to order columns:
# start with the most important univeral columns, then add those from the best data sources
names_order <- c("organization_name", "organization_type", "email_address", "phone_number", 
                 "fax_number", "primary_contact_name", "street_address", "city", "state", 
                 "zip_code", "county", "state_long", "year_founded", "organization_website",
                 "grades_offered", "total_students", "student_body_type", "students_of_color_percentage", 
                 "total_classroom_teachers", "student_teacher_ratio", "religious_affiliation", 
                 "faculty_with_advanced_degree_percentage", "average_class_size", 
                 "average_act_score", "yearly_tuition_cost", "acceptance_rate", 
                 "total_sports_offered", "total_extracurriculars", "early_education_students", 
                 "elementary_students", "middle_school_students", "high_school_students", 
                 "i20_compliant", "grade_levels_taught", "acsi_accreditation_status", 
                 "grades_accredited", "other_accreditations", "special_needs", 
                 "top_leader", "donor_contact", "ecfa_membership_type", 
                 "total_revenue", "total_expenses", "total_assets", "total_liabilities", 
                 "net_assets", "reporting_period", "membership_start_date",                 
                 "lead_source", "lead_source_website")


# reorder each frame so they're all in the same order
setDT(psr)
psr <- psr[, names_order, with = FALSE]

setDT(ecfa)
ecfa <- ecfa[, names_order, with = FALSE]

setDT(acsi)
acsi <- acsi[, names_order, with = FALSE]

setDT(agrm)
agrm <- agrm[, names_order, with = FALSE]

# bind them together into one master set
master_leads <- rbind(psr, acsi, ecfa, agrm)

# create state lookup frame to convert short state names to long, and vice-versa
state_short <- c(
  "AK", "AL", "AR", "AZ", "CA", "CO", 
  "CT", "DC", "DE", "FL", "GA", "HI", "IA", "ID", "IL", "IN", "KS", 
  "KY", "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MS", "MT", "NC", 
  "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", 
  "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VT", "WA", "WI", "WV", 
  "WY"
)

state_long <- c(
  "Alaska", "Alabama", "Arkansas","Arizona",
  "California", "Colorado", "Connecticut", "District-Of-Columbia", "Delaware",
  "Florida", "Georgia", "Hawaii", "Iowa", "Idaho", "Illinois", "Indiana", 
  "Kansas", "Kentucky", "Louisiana", "Massachusetts", "Maryland", "Maine",
  "Michigan", "Minnesota", "Missouri","Mississippi", 
  "Montana", "North-Carolina", "North-Dakota", "Nebraska", "New-Hampshire", "New-Jersey", 
  "New-Mexico", "Nevada", "New-York",  "Ohio", 
  "Oklahoma", "Oregon", "Pennsylvania", "Rhode-Island", "South-Carolina", 
  "South-Dakota", "Tennessee", "Texas", "Utah", "Virginia",  "Vermont", "Washington", 
  "Wisconsin", "West Virginia", "Wyoming"
)

state_lookup <- data.frame(cbind(state_short = state_short, state_long = state_long))
as.data.frame(state_lookup)

# test the state lookup
# base R method:
ecfa_copy <- ecfa
# ecfa_copy$state_long <- state_lookup$state_long[state_lookup$state_short == ecfa_copy$state]


# dplyr method:
master_leads <- dplyr::left_join(master_leads, state_lookup, by = c("state" = "state_short"))
master_leads$state_long.x <- master_leads$state_long.y
master_leads$state_long.y <- NULL
names(master_leads)[names(master_leads) == 'state_long.x'] <- "state_long"

write.csv(master_leads, "/Users/Steve/Desktop/master-leads.csv", row.names = FALSE)

