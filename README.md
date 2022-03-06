# Weather Forecast

## Ruby on Rails demostration project

### Weather retrieval

The weather retrieval uses Geocoder and the weather.gov API

* Geocoder ( http://www.rubygeocoder.com/ ) is used to determine the latitude and longitude of a given city and state. Not every city is returned.

* National Weather Service API ( https://www.weather.gov/documentation/services-web-api ) is used with the city's longitude and latitude to return the forecast.

## Setup

1. Install Ruby version 2.7.5

2. Install bundler and bundle install
```
gem install bundler
bundle install
```

3. Install yarn and yarn install
```
yarn install
```

4. Run the tests
```
bundle exec rspec
yarn jest
```

5. Enable the Rails cache in development
```
bundle exec rails dev:cache
```

6. Run the webpack dev server
```
./bin/webpack-dev-server
```

7. Run the rails server
```
bundle exec rails s
```

8. Navigate to http://localhost:3000/ and enter your city and state for the forecast

## Next steps

The next step is to use a reliable API to retrieve the weather, possibly https://openweathermap.org/api