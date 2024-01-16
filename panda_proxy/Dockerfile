# Use an Elixir base image
FROM elixir:1.16.0-otp-24-slim

# Declare an environment variable
ENV PANDASCORE_AUTH_TOKEN "default"

# Set the working directory inside the container
WORKDIR /app

# Copy the mix.exs and mix.lock files to the container
COPY mix.exs mix.lock ./

# Install the application's dependencies
RUN mix deps.get

# Copy the rest of your application's code
COPY . .

# The command to run when the container starts
CMD ["mix", "run", "--no-halt"]
