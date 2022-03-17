FROM alpine:3.15
ENV APP_USER=regula
ENV APP_DIR=/workspace
RUN adduser -s /bin/true -u 1000 -D -h $APP_DIR $APP_USER
COPY regula /bin/regula
USER ${APP_USER}
WORKDIR ${APP_DIR}
ENTRYPOINT [ "/bin/regula" ]
