# Pandascore challenge

# Setup

### Scrapper
- `cd scrapper && npm install && cd ..`
- Configure  `scrapper/.env`  using `scrapper/.env-example` as a template
- Run `node scrapper/main.mjs`
- This will run the Puppeteer script and generate a new Pandascore Token

# Run the application
- First copy the generated token to the root `.env` (use `.env-example` as template)
- Run `docker compose --env-file .env up --build`
- [Open the webpage](http://localhost:3000/).


# Test
- The Elixir API has some simple tests that can be run with `PANDASCORE_AUTH_TOKEN=XXXXXX mix test`

# Run Iex interpreter by typing iex -S mix
- if you want to run the Elixir interpreter use
`PANDASCORE_AUTH_TOKEN=XXXXX iex -S mix
`
