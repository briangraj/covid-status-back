Rails.application.routes.draw do
  scope "/covid" do
    get "total", to: "stats#total", as: "covid_total"
    get "deaths", to: "stats#deaths", as: "covid_deaths"
    get "update", to: "updates#show", as: "covid_update"
  end
end
