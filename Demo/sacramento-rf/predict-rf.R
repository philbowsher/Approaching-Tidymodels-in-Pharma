library(tidyverse)
library(vetiver)

#step 3 use consumed model
# you have to set the endpoint like:
# endpoint <- vetiver_endpoint("https://connecturl/public/sacramento_rf_phil/predict")
# So the odd part here, is that the endpoint is via predict - thats not the content name but the endpoint for the content,sacramento_rf_phil !
# Below we are going to use the usethis::edit_r_environ() to set
# phil_endpoint_sac="https://YOURSERVER/rsconnect/sacramento_rf_phil/predict"
# VETIVER_API="yourconnectkey"
# make sure to set the CONTENT URL Path to /sacramento_rf_phil/ in Connect
# The api can be open or locked to certain groups
# not sure if "public" is needed in training env

#grab 20 random reconds and columns needed for predictions
data(Sacramento, package = "modeldata")
new_sac <- Sacramento %>%
    slice_sample(n = 20) %>%
    select(type, sqft, beds, baths)

new_sac

vet_api_key <- Sys.getenv("VETIVER_API")
# apiKey <- Sys.getenv("")

# has to be the /predict endpoint at that specific API like
# vetiver_endpoint("http://ec2-18-216-69-78.us-east-2.compute.amazonaws.com/rsconnect/sacremento_rf_phil/predict")
# we are pulling from the Renviron
# Make sure to set phil_endpoint_sac in your .Renviron file
#I left this as Phil but you could change it to your first name if you like
phil_endpoint <-  vetiver_endpoint(Sys.getenv("phil_endpoint_sac"))
  

# call it with auth (API key)
res <- predict(phil_endpoint, new_sac, httr::add_headers(Authorization = paste("Key", vet_api_key)))

new_sac %>% mutate(result = res)
