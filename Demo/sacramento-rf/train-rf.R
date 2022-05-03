library(tidymodels)
data(Sacramento)

#predict price for a bunch of random houses
rf_spec <- rand_forest(mode = "regression")
rf_form <- price ~ type + sqft + beds + baths

rf_fit <-
    workflow(rf_form, rf_spec) %>%
    fit(Sacramento)

rf_fit

library(vetiver)
v <- vetiver_model(rf_fit, "sacramento_rf_phil")
v

#step2
library(pins)
model_board <- board_rsconnect(
    auth = "envvar",
    server = Sys.getenv("CONNECT_SERVER"), # Sys.getenv("CONNECT_SERVER")
    account = "gt",
    key = Sys.getenv("VETIVER_API"))
model_board %>% vetiver_pin_write(v)

#plumber deploy
vetiver_deploy_rsconnect(
    model_board,
    "gt/sacramento_rf_phil",
    predict_args = list(debug = TRUE),
    account = "gt"
)
