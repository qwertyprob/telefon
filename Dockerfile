FROM ruby:2.1.10

RUN echo "deb http://archive.debian.org/debian jessie main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list && \
    apt-get -o Acquire::Check-Valid-Until=false update -qq && apt-get install -y --allow-unauthenticated \
  build-essential \
  libsqlite3-dev \
  nodejs \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --without test doc

COPY . .

RUN bundle exec rake assets:precompile RAILS_ENV=production SECRET_KEY_BASE=placeholder

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-e", "production"]
