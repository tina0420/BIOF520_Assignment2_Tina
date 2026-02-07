# Import library
# install.packages("arrow")
library(arrow)
library(dplyr)

# Set the working directory
getwd()
setwd("C:/Users/tttin/Course/BIOF520/Assignment2")

# Read the file
data_load <- readRDS("UROMOL_TaLG.teachingcohort.rds")

# Extract the clinical data and output
subset_df <- data_load %>% select(-last_col())
write_parquet(as.data.frame(subset_df), "UROMOL_clinical.parquet")

# Extract the RNA-Seq data and output
subset_df <- data_load$exprs
write_parquet(as.data.frame(subset_df), "UROMOL_rnaseq.parquet")

# Read the data for validation
data <- readRDS("knowles_matched_TaLG_final.rds")

subset_df <- data %>% select(-(exprs))
write_parquet(as.data.frame(subset_df), "knowles_clinical.parquet")

subset_df <- data$exprs
write_parquet(as.data.frame(subset_df), "knowles_microarray.parquet")

