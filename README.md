Coffeespy is a client-server application built using Phoenix as the backend JSON API server and Flutter as the front end.

Coffee_app contains the Flutter DART, coffee_prices contains the Elixir code.

To run, you will need to use the Docker file found in coffee_prices, then run the ecto migrations to setup the database. Once this is done, you'll need to run the phoenix server and pass the API URL as a commandline argument into Flutter