FROM alpine:3.4
RUN apk --no-cache add curl ca-certificates bash
COPY kubectl-v1.18.8 /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl
COPY update.sh /bin/
COPY init-cluster.sh /bin/
ENTRYPOINT ["sh","/bin/update.sh"]