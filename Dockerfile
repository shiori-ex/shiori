FROM elixir:alpine

WORKDIR /app

COPY config config
COPY lib lib
COPY mix.exs .
COPY mix.lock .

RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && mix deps.compile

ENV SHIORI_WS_USEHTTPS="false" \
    SHIORI_WS_PORT="8080"

EXPOSE 8080

ENTRYPOINT ["mix", "run", "--no-halt"]