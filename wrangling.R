library(tidyverse)
library(tidymodels)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
df_init <- read_delim("OECD_econ_data_2.csv",delim=",")
# data source: OECD
head(df_init)
df_init <- filter(df_init, Measure == "Current prices")
df_init <- mutate(df_init, transact = paste(TRANSACT, Transaction, sep=" "))
df <- df_init |> select(transact,Year,Value)
options(tibble.print_min = 10)
df

# To get pivot_wider to work, I need to specify only the columns that I will be using in the analysis.

df <- pivot_wider(df, names_from = transact, values_from=Value)
print(select(df,`Gross domestic product (output approach)`,`Gross value added at basic prices, excluding FISIM`),n=20)
glimpse(df)
# Get more years from the original dataset
# This'll do for now

df <- df |> select_if(~ !any(is.na(.))) # This is the better solution
df
df_no_2021 <- filter(df, Year != 2021)
df_no_2021

df_no_2021['next_yr_gdp'] <- 0
iteration_var <- seq(1,length(df_no_2021$Year),by=1)
iteration_var
for (i in iteration_var){
  df_no_2021$next_yr_gdp[i] <- df$`B1_GA Gross domestic product (output approach)`[i+1]
}
df_no_2021$next_yr_gdp
df_no_2021 <- select(df_no_2021,-Year)
df_no_2021
split <- initial_split(df_no_2021, 
                       prop=0.75, 
                       strata = `B1_GA Gross domestic product (output approach)`)
df_train <- training(split)
df_train
df_test <- testing(split)
df_test
glimpse(df_train)

write_delim(df_train, file = "oecd_tidied_train.csv",delim = ",")
write_delim(df_test, file = "oecd_tidied_test.csv",delim = ",")