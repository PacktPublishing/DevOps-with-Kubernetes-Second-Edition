FROM ubuntu:bionic

RUN apt-get update && apt-get install -y --no-install-recommends \
     git openssl wget unzip ca-certificates \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean \
  && wget -qO /bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(wget -qO - https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
  && chmod +x /bin/kubectl

ADD watcher.sh /

ENTRYPOINT ["/watcher.sh"]
