# Pandascore challenge

# Setup

### Scrapper
- `cd scrapper && npm install && cd ..`
- Configure  `scrapper/.env`  using `scrapper/.env-example` as a template
- Run `node scrapper/main.mjs`
- This will run the Puppeteer script and generate a new Pandascore Token

### Panda Frontend
- Since the React project is setup to use hot reloading for easier programming we need to go to the frontend folder and install node_modules `cd panda_frontend && npm install && cd ..`´


# Run the application
- The project assumes that Postgres is installed in the host machine (with username and password being the default `postgres`) and that the host machine is Linux
- First copy the generated token to the root `.env` (use `.env-example` as template)
- Run `docker compose --env-file .env up --build`
- [Open the webpage](http://localhost:3000/).


# Test
- The Elixir API has some simple tests that can be run with `PANDASCORE_AUTH_TOKEN=XXXXXX mix test`
- I was having trouble setting Ecto in sandbox mode hence the lack of unit tests for the `Match` class
