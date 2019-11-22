FROM kiora/php:7.3
ARG YARN_VERSION=1.12.3
ARG GULP_VERSION=2.0.1
ARG NODE_VERSION=8
ARG SCSS_LINT=0.57.1

MAINTAINER Stéphane Rathgeber <stephane.kiora@gmail.com>

RUN apt-get update && apt-get install -y \
    openssl\
    git\
    zsh\
    bash-completion\
    vim \
    openssh-server\
    nano\
    curl \
    ruby-full

# Install Composer
ENV COMPOSER_ALLOW_SUPERUSER=1 COMPOSER_MEMORY_LIMIT=-1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && composer --version


RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
  && apt-get install -y nodejs \
  && curl -L https://www.npmjs.com/install.sh | sh

RUN npm install --global yarn@${YARN_VERSION} \
  && npm install --global gulp-cli@${GULP_VERSION}

#install scss_lint
RUN gem install scss_lint -v ${SCSS_LINT}

#oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

RUN mkdir /var/run/sshd \
&& echo 'root:passwd' | chpasswd \
&& sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
&& sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

COPY init.sh /init.sh
RUN chmod +x /init.sh

VOLUME /root/.ssh
EXPOSE 22
WORKDIR /var/www
CMD ["/init.sh"]
