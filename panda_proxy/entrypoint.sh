#!/bin/bash
# Docker entrypoint script.

mix ecto.migrate
mix run --no-halt
