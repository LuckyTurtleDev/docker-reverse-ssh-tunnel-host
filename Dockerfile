FROM alpine

Run apk update \
 && apk add \
      openssh \
      ca-certificates \
 && cp /etc/ssh/sshd_config /sshd_config

ADD entrypoint.sh /entrypoint.sh

RUN addgroup --gid 1000 -S user \
 && adduser -u 1000 -S user -G user \
 && chown user -R /etc/ssh/ \
 && chmod a+x /entrypoint.sh

USER user:user

CMD ["/entrypoint.sh"]
