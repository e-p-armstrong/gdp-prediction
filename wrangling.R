library(tidyverse)
library(tidymodels)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
df_init <- read_delim("OECD_econ_data.csv",delim=",")
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

next_year_gdp <- df_no_2021$`B1_GA Gross domestic product (output approach)`
next_year_gdp
length(df$`B1_GA Gross domestic product (output approach)`)
length(next_year_gdp)
for (gdp in next_year_gdp){
  
}
df$`Households and Non-profit institutions serving households`
mutate(df_no_2021, filter(df, year =) |> pull())
# Confirmed: making a new variable in R copies the data
















split <- initial_split(df_for_dectree, prop=0.75, strata = `marital-status`)
df_train <- training(split)
df_train
df_test <- testing(split)
df_test

write_delim(df_train, file = "adult-one-hot-train.csv",delim = ",")
write_delim(df_test, file = "adult-one-hot-test.csv",delim = ",")

df_for_dectree_2 <- select(df, -age,-workclass,-education,-`educational-num`,-occupation,-relationship,-`capital-gain`,-`capital-loss`,-`hours-per-week`,-`native-country`,-`income`,-`race`,-`gender`)
colnames(df_for_dectree_2)
df_for_dectree_2

split <- initial_split(df_for_dectree_2, prop=0.75, strata = `fnlwgt`)
df_train <- training(split)
df_train
df_test <- testing(split)
df_test

write_delim(df_train, file = "adult-one-hot-train-income.csv",delim = ",")
write_delim(df_test, file = "adult-one-hot-test-income.csv",delim = ",")

