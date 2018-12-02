FROM ruby:2.5

RUN apt-get update -qq && \
      apt-get install -y curl apt-transport-https

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get update -qq && \
    apt-get install -y \
      build-essential \
      libpq-dev \
      nodejs \
      make \
      libzmq3-dev \
      libczmq-dev \
      libsqlite3-dev \
      zlib1g-dev \
      fonts-liberation \
      libappindicator3-1 \
      libasound2 \
      libatk-bridge2.0-0 \
      libgtk-3-0 \
      libnspr4 \
      libnss3 \
      libx11-xcb1 \
      libxss1 \
      libxtst6 \
      lsb-release \
      xdg-utils \
      yarn

RUN curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb
RUN dpkg -i /chrome.deb || apt-get install -yf
RUN rm /chrome.deb

# Install chromedriver for Selenium
RUN curl https://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip -o /usr/local/bin/chromedriver
RUN chmod +x /usr/local/bin/chromedriver

RUN mkdir /dashboard
WORKDIR /dashboard
COPY Gemfile /dashboard/Gemfile
COPY Gemfile.lock /dashboard/Gemfile.lock
RUN bundle install
COPY . /dashboard
