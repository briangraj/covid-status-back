# Covid Status

## Requirements to run this app:
* [Ruby 3.1.0](https://www.ruby-lang.org/en/documentation/installation/)
* [Ruby on Rails 7.0.2.3](https://guides.rubyonrails.org/getting_started.html#installing-ruby)

## Environment variable
Use the variable `DATASET_URL` to set where the dataset is downloaded from. This can be done creating a file `.env` in the root of the project, with this:
```dotenv
DATASET_URL=https://...
```

### Datasets
Some datasets to use
+ [1000 records](https://github.com/briangraj/datos/raw/main/1000.zip)
+ [5000 records](https://github.com/briangraj/datos/raw/main/5000.zip)

## Run the app
1. Clone repo
```shell
git clone git@github.com:briangraj/covid-status-back.git
cd covid-status-back/
```

2. Install gems
```shell
bundle install
```

3. Start the server
```shell
bin/rails server
```

The server runs on [http://localhost:8080](http://localhost:8080)
