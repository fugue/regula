FROM scratch
ENTRYPOINT [ "/usr/local/bin/regula" ]
COPY regula /usr/local/bin/regula
