# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.3.9
FROM ruby:$RUBY_VERSION-slim

# Instala dependencias del sistema necesarias para Rails y Psych
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
  build-essential \
  git \
  curl \
  libpq-dev \
  nodejs \
  npm \
  libyaml-dev \
  zlib1g-dev \
  libffi-dev \
  libvips \
  postgresql-client \
  ca-certificates \
  libssl-dev \
  tzdata \
  procps \
  && npm install -g yarn \
  && rm -rf /var/lib/apt/lists/*

# Directorio de trabajo
WORKDIR /app

# Copia los archivos de dependencias primero (para aprovechar cache)
COPY Gemfile Gemfile.lock ./

# Instala gems del proyecto
RUN bundle install

# Copia el resto del código
COPY . .

# Exponer puerto
EXPOSE 3001

# Comando por defecto al iniciar el contenedor
# Eliminamos el pid viejo si existe (evita "A server is already running (pid...)")
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0 -p 3001"]
