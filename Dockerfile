FROM python:3.7.5-alpine3.10

RUN apk update && \
    apk add git

RUN python -m pip install --upgrade pip && \
    pip install git+https://github.com/xbmc/kodi-addon-submitter.git

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
