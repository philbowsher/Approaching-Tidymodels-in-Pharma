library(tidyverse)
library(vetiver)

endpoint <- vetiver_endpoint("http://ec2-18-216-69-78.us-east-2.compute.amazonaws.com/rsconnect/predict/")
endpoint

data(Sacramento, package = "modeldata")
new_sac <- Sacramento %>%
    slice_sample(n = 20) %>%
    select(type, sqft, beds, baths)

apiKey <- Sys.getenv("")
predict(endpoint, new_sac, httr::add_headers(Authorization = paste("Key", apiKey)))
