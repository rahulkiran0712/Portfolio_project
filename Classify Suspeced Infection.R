# Loading packages.
install.packages('data.table')
library(data.table)

# Sort the data and examine the first 40 rows
setorder(x = antibioticDT, patient_id, antibiotic_type, day_given)
antibioticDT[1:40]

# Use shift to calculate the last day a particular drug was administered
antibioticDT[ , last_administration_day := shift(day_given, n = 1, type = "lag"), 
              by = .(patient_id, antibiotic_type)]

# Calculate the number of days since the drug was last administered
antibioticDT[ , days_since_last_admin := day_given - last_administration_day]

# Create antibiotic_new with an initial value of one, then reset it to zero as needed
antibioticDT[, antibiotic_new := 1]
antibioticDT[days_since_last_admin <= 2, antibiotic_new := 0]
antibioticDT[1:40]

# Investigate the blood culture data.
blood_cultureDT[1:40]

# Merge the antibiotic data with the blood culture data.
merged_df <- merge(antibioticDT, blood_cultureDT, by = 'patient_id')
merged_df[1:40]
View(merged_df)

# Sort by patient_id, blood_culture_day, day_given, and antibiotic_type
setorder(x= merged_df, patient_id, blood_culture_day, day_given, antibiotic_type )
merged_df[1:30]

#Make a new variable indicating whether or not the antibiotic administration and blood culture are within two days of each other. 
merged_df[, drug_in_bcx_window := 1]
merged_df[blood_culture_day <= 2 & last_administration_day <= 2, drug_in_bcx_window := 0]
View(merged_df)

# For each patient/blood culture day combination, 
#determine if at least one I.V. antibiotic was given in the +/-2 day window.
merged_df[, any_iv_in_bcx_window := 1]
merged_df[drug_in_bcx_window == 0 & route == "IV", any_iv_in_bcx_window := 0, by = .(patient_id,blood_culture_day)]
View(merged_df)
merged_df[, na.omit(last_administration_day,days_since_last_admin)]
View(merged_df)

# Sorting data by Day
setorder(x = merged_df, day_given)
View(merged_df)

# Task7:Instructions for each blood culture, find the first day of potential 4-day antibiotic sequences.This day will be the first day that is both in the window, and a new antibiotic was given.
merged_df[, day_of_first_new_abx_in_window := day_given == 1 ]
View(merged_df)

# Create a new data.table
new_df <- merged_df[, list(patient_id,blood_culture_day,day_given)]
View(new_df)

# Removing duplicates
df <- new_df[!duplicated(new_df),]
View(df)

# Make a new variable, num_antibiotic_days, showing the number of antibiotic days each patient/blood culture day combination.

df[, num_antibiotic_days := .N , by = patient_id]
View(df)

# Remove blood culture days with less than four antibiotic days (rows).

DF <- df[num_antibiotic_days > 4 ]

# Select the first four days (rows) for each blood culture.
head(DF[, print(.SD[1:4])])

skipped_days <- df[, diff(num_antibiotic_days, lag = 1, differences = 2)]
print(skipped_days)

DF[, four_in_seq := 0]
DF[skipped_days > 1, four_in_seq := 1]

View(DF)






