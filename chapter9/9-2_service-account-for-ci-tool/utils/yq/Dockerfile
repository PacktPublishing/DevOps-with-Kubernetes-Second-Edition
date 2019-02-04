FROM python:alpine

ENTRYPOINT ["yq"]

RUN apk add --no-cache jq && pip install yq --no-cache-dir
