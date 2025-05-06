# This is a R file, we will use a RMD/QMD in the next example.

library(tidymodels)
data(Sacramento)

#predict price for a bunch of random houses
rf_spec <- rand_forest(mode = "regression")
rf_form <- price ~ type + sqft + beds + baths

rf_fit <-
    workflow(rf_form, rf_spec) %>%
    fit(Sacramento)

rf_fit

# Save out model and get it ready to host online
# Vetiver model sacramento_rf_phil, is the name of the model to be pinned in Connect
library(vetiver)
v <- vetiver_model(rf_fit, "sacramento_rf_phil")
v

# https://colorado.posit.co/rsc/ShinyDeployWorkshop/ShinyRSCWorkshop.html#13
# This will explain how to setup the Environment Vars "envvar"
# Please see Renviron_example.txt
# usethis::edit_r_environ()

#step2
library(pins)
model_board <- board_connect(
    auth = "envvar",
    server = Sys.getenv("CONNECT_SERVER"), # Sys.getenv("CONNECT_SERVER")
    account = "tidymodels",
    key = Sys.getenv("VETIVER_API"))
model_board %>% vetiver_pin_write(v)

#plumber deploy
vetiver_deploy_rsconnect(
    model_board,
    "sacramento_rf_phil",
    predict_args = list(debug = TRUE),
    account = "tidymodels"
)


# After we deploy, we can test API in Connect, make sure to set string as "Residential"
