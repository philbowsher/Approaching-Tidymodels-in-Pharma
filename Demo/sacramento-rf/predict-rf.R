library(tidyverse)
library(vetiver)

#step 3 use consumed model
# endpoint <- vetiver_endpoint("http://ec2-18-216-69-78.us-east-2.compute.amazonaws.com/rsconnect/predict/")
# endpoint

#grab 20 random reconds and columns needed for predictions
data(Sacramento, package = "modeldata")
new_sac <- Sacramento %>%
    slice_sample(n = 20) %>%
    select(type, sqft, beds, baths)

new_sac

vet_api_key <- Sys.getenv("VETIVER_API")
# apiKey <- Sys.getenv("")

# has to be the /predict endpoint at that specific API
# vetiver_endpoint("http://ec2-18-216-69-78.us-east-2.compute.amazonaws.com/rsconnect/sacremento_rf_phil/predict")
phil_endpoint <-  vetiver_endpoint(Sys.getenv("phil_endpoint_sac"))
  

# call it with auth (API key)
res <- predict(phil_endpoint, new_sac, httr::add_headers(Authorization = paste("Key", vet_api_key)))

new_sac %>% mutate(result = res)
