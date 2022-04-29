library(tidymodels)
data(Sacramento)

rf_spec <- rand_forest(mode = "regression")
rf_form <- price ~ type + sqft + beds + baths

rf_fit <-
    workflow(rf_form, rf_spec) %>%
    fit(Sacramento)

library(vetiver)
v <- vetiver_model(rf_fit, "sacramento_rf_phil")
v

library(pins)
model_board <- board_rsconnect(
    auth = "envvar",
    server = "http://ec2-18-216-69-78.us-east-2.compute.amazonaws.com/rsconnect/", # Sys.getenv("CONNECT_SERVER")
    account = "gt",
    key = "")
model_board %>% vetiver_pin_write(v)

vetiver_deploy_rsconnect(
    model_board,
    "gt/sacramento_rf_phil",
    predict_args = list(debug = TRUE),
    account = "gt"
)
