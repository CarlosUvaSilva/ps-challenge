FROM elixir:1.16.0-otp-24-slim

ENV PANDASCORE_AUTH_TOKEN "default"

WORKDIR /app

COPY mix.exs mix.lock ./

RUN mix deps.get

COPY . .

ENTRYPOINT [ "./entrypoint.sh" ]
