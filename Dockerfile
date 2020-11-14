FROM kiora/php:latest

ARG YARN_VERSION=1.16.0
ARG NODE_VERSION=12
ARG SCSS_LINT=0.57.1

LABEL maintainer="stephane.kiora@gmail.com"

RUN apt-get update && apt-get install -y \
    openssl\
    git\
    bash-completion\
    vim \
    nano\
    curl \
    ruby-full \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Composer
ENV COMPOSER_ALLOW_SUPERUSER=1 COMPOSER_MEMORY_LIMIT=-1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && composer --version


RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
  && apt-get install -y nodejs \
  && curl -L https://www.npmjs.com/install.sh | sh

RUN npm install --global yarn@${YARN_VERSION} \
  && npm install --global webpack

#install scss_lint
RUN gem install scss_lint -v ${SCSS_LINT}


ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

COPY init.sh /init.sh
RUN chmod +x /init.sh

RUN groupadd -g 1000 -r kiora \
 && useradd -u 1000 -r -g kiora kiora \
 && mkdir -p /home/kiora/.ssh \
 && chown -R kiora:kiora /home/kiora \
 && chown -R kiora:kiora /var/www

USER kiora

VOLUME /home/kiora/.ssh
WORKDIR /var/www
ENTRYPOINT ["/bin/bash"]
CMD ["/init.sh"]
