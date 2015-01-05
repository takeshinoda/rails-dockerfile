FROM ubuntu:14.10

# timezone
RUN ln -sf /usr/share/zoneinfo/Japan /etc/localtime

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

# locale
RUN apt-get install -y --force-yes language-pack-ja
RUN locale-gen ja_JP.UTF-8  
ENV LANG ja_JP.UTF-8  
ENV LANGUAGE ja_JP:en  
ENV LC_ALL ja_JP.UTF-8 

# ruby
RUN apt-get install -y --force-yes autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev

# rbenv-build
RUN apt-get install -y --force-yes curl git

# pg
RUN apt-get install -y --force-yes libpq-dev

RUN apt-get clean

# install rbenv
RUN git clone https://github.com/sstephenson/rbenv.git /usr/share/rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/share/rbenv/plugins/ruby-build

ENV PATH /usr/share/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/share/rbenv

WORKDIR /usr/share/rbenv/plugins/ruby-build
RUN ./install.sh
WORKDIR /root

RUN echo 'export RBENV_ROOT=/usr/share/rbenv' > /etc/profile.d/rbenv.sh
RUN echo 'export PATH=$RBENV_ROOT/bin:$PATH' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /etc/bash.bashrc

# install ruby
RUN rbenv install 2.2.0
RUN rbenv global 2.2.0
RUN rbenv rehash

RUN echo 'install: --no-document' > ~/.gemrc
RUN echo 'update: --no-document' >> ~/.gemrc
RUN bash -l -c 'gem install bundler'
RUN bash -l -c 'gem install rails ">~4.2.0"'

