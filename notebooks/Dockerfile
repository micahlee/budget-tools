FROM jupyter/base-notebook

USER root

RUN apt-get update -y && \
    apt-get install -y \
        git \
        curl \
        libtool \
        libffi-dev \
        ruby \
        ruby-dev \
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
        xdg-utils

RUN curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb
RUN dpkg -i /chrome.deb || apt-get install -yf
RUN rm /chrome.deb

# Install chromedriver for Selenium
RUN curl https://chromedriver.storage.googleapis.com/2.31/chromedriver_linux64.zip -o /usr/local/bin/chromedriver
RUN chmod +x /usr/local/bin/chromedriver

RUN gem install cztop iruby
RUN iruby register --force

RUN gem install sqlite3 watir webdrivers ynab activesupport

RUN pip install numpy

USER $NB_UID
