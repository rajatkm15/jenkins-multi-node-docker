FROM jenkins/ssh-agent:alpine
USER root
RUN apk add --no-cache docker-cli && apk add --no-cache openjdk21
COPY ./entrypoint.sh /
RUN chmod u+x /entrypoint.sh
ENTRYPOINT ["/bin/bash","/entrypoint.sh"]
