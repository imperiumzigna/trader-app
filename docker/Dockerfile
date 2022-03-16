FROM ruby:2.6.5-slim-stretch

ARG DEBIAN_FRONTEND=noninteractive
ARG NODE_MAJOR=12

# Dist upgrade
RUN apt-get update -yqq \
  && apt-get -yq dist-upgrade

# Common dependencies
# curl is used to add new references to sources list
# libfontconfig is required by PhantomJS
# libpq-dev is required by gem pg2
# openssh-client gnupg2 required to add git credentials
RUN apt-get update -qq \
  && apt-get install -yqq --no-install-recommends \
  apt-transport-https \
  build-essential \
  curl \
  gnupg2 \
  libfontconfig \
  libpq-dev \
  openssh-client

# Add NodeJS to sources list
RUN curl -sSL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -

# Install Core Application dependencies
RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
  git \
  nodejs \
  unzip \
  wget

RUN npm install --global yarn
# Clear temporary files of installation
RUN apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Set up the Chrome PPA
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# # Install phantomjs (there will be no new versions of PhantomJS, so it is safe to fix the last version)
ARG PHANTOMJS_VERSION=2.1.1
RUN mkdir -p /srv/var \
  && curl -sSL -o /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 \
  && tar -xjf /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 -C /tmp \
  && rm -f /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 \
  && mv /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/ /srv/var/phantomjs \
  && ln -s /srv/var/phantomjs/bin/phantomjs /usr/bin/phantomjs

# install google chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get -y update
RUN apt-get install -y google-chrome-stable

# install chromedriver
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

# set display port to avoid crash
ENV DISPLAY=:99

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_BIN=/usr/src/gems/bin \
  BUNDLE_JOBS=4 \
  BUNDLE_PATH=/usr/src/gems \
  BUNDLE_RETRY=3 \
  GEM_HOME=/usr/src/gems \
  BUNDLER_VERSION=2.3.4

# Upgrade RubyGems and install required Bundler version
RUN gem update --system 
RUN gem install bundler -v '2.3.4'

# Run binstubs without prefixing with `bin/` or `bundle exec`
ENV PATH=$PATH:$BUNDLE_BIN

# Create a directory for the app code
RUN mkdir -p /website

WORKDIR /website

# Install gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install
RUN yarn
RUN npm rebuild node-sass

