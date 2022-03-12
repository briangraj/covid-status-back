Rails.application.routes.draw do
  scope "/covid" do
    get "total", to: "stats#total", as: "covid_total"
  end
end
