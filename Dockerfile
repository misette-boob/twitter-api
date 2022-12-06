FROM elixir:1.13.4

# Build Args
ARG PHOENIX_VERSION=1.6.11
ARG NODEJS_VERSION=16.x
ARG UID=1000
ARG GID=1000

# App Directory
ENV APP_HOME /app

# Apt
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y apt-utils build-essential inotify-tools && \
# Nodejs
    curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION} | bash && \
    apt-get install -y nodejs && \
# Clear
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean
# User
RUN groupadd -g "${GID}" elixir && \
    useradd --create-home --no-log-init -u "${UID}" -g "${GID}" elixir && \
    mkdir -p $APP_HOME && chown elixir:elixir -R $APP_HOME

USER elixir

# Phoenix
RUN mix local.hex --force && \
    mix archive.install --force hex phx_new && \
    mix local.rebar --force

WORKDIR $APP_HOME

# App Port
EXPOSE 4000

# Default Command
CMD ["mix", "phx.server"]
