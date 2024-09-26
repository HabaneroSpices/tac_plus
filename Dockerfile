FROM alpine:latest
USER root

RUN apk add --no-cache \
        build-base \
        c-ares-dev \
        curl \
        curl-dev \
        freeradius-client-dev \
        libretls-dev \
        linux-pam-dev \
        openssl-dev \
        pcre2-dev \
        perl \
        perl-authen-radius \
        perl-ldap \
        perl-net-ip \
        perl-sys-syslog \
        && echo "[PACKAGES INSTALLED]"

RUN wget https://github.com/MarcJHuber/event-driven-servers/archive/refs/heads/master.zip -O event-driven-servers-master.zip && \
    unzip event-driven-servers-master.zip && \
    cd event-driven-servers-master && \
    ./configure tac_plus --etcdir=/etc/tac_plus && \
    make && \
    make install && \
    echo "[TAC_PLUS BUILD]"

RUN mkdir -p /var/log/tac_plus && \
    chmod -R 755 /var/log/tac_plus

RUN touch /etc/tac_plus/tac_plus.cfg && \
    chmod 755 /etc/tac_plus/tac_plus.cfg && \
    cp /event-driven-servers-master/tac_plus/sample/tac_plus.cfg /etc/tac_plus/tac_plus.cfg

COPY tac_plus-msldap.cfg /etc/tac_plus/tac_plus-msldap.cfg

# Verify Ldap capabilities - This will fail, but the output should be as expected
RUN /usr/local/lib/mavis/mavis_tacplus_ldap.pl < /dev/null || \
    echo -e "This is a ldap capability check. The error can be ignored."

EXPOSE 49

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

