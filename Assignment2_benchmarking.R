# Run the published classifier
# Install the packages (if not installed yet)
# install.packages("devtools")
# devtools::install_github("sialindskrog/classifyNMIBC")
# install.packages("arrow")

library(classifyNMIBC)
library(arrow)
library(dplyr)
library(ggplot2)

# Set the working directory
getwd()
# setwd("C:/Users/tttin/Course/BIOF520/Assignment2")

# Read in the RNA-Seq and microarray data
data_rna <- read_parquet("UROMOL_rnaseq.parquet")
rna_clinical <- read_parquet("UROMOL_clinical.parquet")
data_microarray <- read_parquet("knowles_microarray.parquet")
microarray_clinical <- read_parquet("knowles_clinical.parquet")

data_rna <- t(data_rna)
test <- as.data.frame(data_rna)
result <- classifyNMIBC(test, gene_id = "hgnc_symbol")

# Compare the classification result and the real labels from clinical data
rna_clinical <- rna_clinical %>%
  mutate(UROMOL2021.classification = recode(UROMOL2021.classification,
                                            "Class 1" = "Class_1",
                                            "Class 2a" = "Class_2a",
                                            "Class 2b" = "Class_2b",
                                            "Class 3" = "Class_3"))
rna_clinical$UROMOL2021.classification <- factor(rna_clinical$UROMOL2021.classification)
result$NMIBC_class <- factor(result$NMIBC_class, levels = levels(rna_clinical$UROMOL2021.classification))

cm <- table(Actual = rna_clinical$UROMOL2021.classification,
            Predicted = result$NMIBC_class)

df_cm <- as.data.frame(cm)

ggplot(df_cm, aes(x = Predicted, y = Actual, fill = Freq)) +
  geom_tile(color = "white") +
  geom_text(aes(label = Freq), size = 5) +
  scale_fill_gradient(low = "#F1EEF6", high = "#045A8D") +
  labs(title = "classifyNMIBC-RNA",
       x = "Predicted",
       y = "Actual") +
  theme_minimal()

# Same approach running with microarray data
data_microarray <- t(data_microarray)
test <- as.data.frame(data_microarray)
result <- classifyNMIBC(test, gene_id = "hgnc_symbol")

# Compare the classification result and the real labels from clinical data
microarray_clinical$UROMOL2021.classification <- factor(microarray_clinical$UROMOL2021.classification)
result$NMIBC_class <- factor(result$NMIBC_class, levels = levels(microarray_clinical$UROMOL2021.classification))

cm <- table(Actual = microarray_clinical$UROMOL2021.classification,
            Predicted = result$NMIBC_class)

df_cm <- as.data.frame(cm)

ggplot(df_cm, aes(x = Predicted, y = Actual, fill = Freq)) +
  geom_tile(color = "white") +
  geom_text(aes(label = Freq), size = 5) +
  scale_fill_gradient(low = "#F1EEF6", high = "#045A8D") +
  labs(title = "classifyNMIBC-Microarray",
       x = "Predicted",
       y = "Actual") +
  theme_minimal()
