FROM sandhya/tomcat8:latest
MAINTAINER Sandhya Nayak

RUN echo setting environments HTTPD_PREFIX ,PATH
ENV HTTPD_PREFIX /usr/local/apache2
ENV PATH $PATH:$HTTPD_PREFIX/bin;
ENV domainname 192.168.99.100

RUN mkdir -p "$HTTPD_PREFIX"

# install httpd runtime dependencies
# https://httpd.apache.org/docs/2.4/install.html#requirements
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
libapr1 \
libaprutil1 \
libaprutil1-ldap \
libapr1-dev \
libaprutil1-dev \
libpcre++0 \
libssl1.0.0 \
&& rm -r /var/lib/apt/lists/*

RUN buildDeps=' \
ca-certificates \
curl \
bzip2 \
gcc \
libpcre++-dev \
libssl-dev \
make \
' \
set -x \
&& apt-get update \
&& apt-get install -y --no-install-recommends $buildDeps \
&& rm -r /var/lib/apt/lists/*

RUN echo Installing apache
WORKDIR /usr/local/

RUN wget -q https://www.apache.org/dist/httpd/httpd-2.4.20.tar.bz2 \
&& tar -xvf httpd-2.4.20.tar.bz2 \
&& rm httpd-2.4.20.tar.bz2 \
&& cd httpd-2.4.20

WORKDIR /usr/local/httpd-2.4.20/
RUN ./configure \
--prefix="$HTTPD_PREFIX" \
--enable-mods-shared=reallyall \
&& make -j"$(nproc)" \
&& make install
WORKDIR /usr/local/
RUN rm -r httpd-2.4.20

WORKDIR $HTTPD_PREFIX/conf
ADD set_http_proxy.sh .

#Uncomment below line 59-60 to generate server certificate for ssl support
#ADD generate_server_crt.sh .
#ADD set_http_ssl.sh .
RUN chmod 777 *.sh

RUN echo Setting httpd.conf using script for proxy support
#Add script
RUN $HTTPD_PREFIX/conf/set_http_proxy.sh $domainname

#Uncomment below line 68-72 to generate server certificate for ssl supports
#RUN echo Generating server certificate
#RUN ./generate_server_crt.sh $domainname

#RUN echo Setting httpd.conf using script for https support
#RUN ./set_http_ssl.sh $domainname

CMD /usr/local/apache2/bin/apachectl -DFOREGROUND
