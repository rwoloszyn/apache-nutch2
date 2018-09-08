FROM java:8

MAINTAINER Rafal Woloszyn <rafal@debugduckdesign.com>

ENV NUTCH_HOME /root/nutch
ENV PHANTOM_JS phantomjs-2.1.1-linux-x86_64

WORKDIR /root/

RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get install -y \
    ant \
    openssh-server \
    vim \
    telnet \
    git \
    rsync \
    curl \
    build-essential \
    chrpath \
    libssl-dev \
    libxft-dev \
    libfreetype6 \
    libfreetype6-dev \
    libfontconfig1 \
    libfontconfig1-dev

# Install PhantomJS
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2 && \
    tar xvjf $PHANTOM_JS.tar.bz2 && \
    mv $PHANTOM_JS /usr/local/share && \
    ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin

RUN wget https://github.com/apache/nutch/archive/master.zip && unzip master.zip && mv nutch-master nutch_source && cd nutch_source && ant

RUN ln -s nutch_source/runtime/local $NUTCH_HOME

ADD nutch-startup.sh /root/nutch-startup.sh
RUN chmod +x /root/nutch-startup.sh

ENTRYPOINT ["/root/nutch-startup.sh"]
