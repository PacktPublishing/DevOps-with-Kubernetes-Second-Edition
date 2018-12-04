FROM ubuntu:bionic

RUN apt-get update && apt-get install -y --no-install-recommends \
     git openssl python3-pip wget unzip \
  && rm -rf /var/lib/apt/lists/* \
  && wget -qO /bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(wget -qO - https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
  && chmod +x /bin/kubectl

ADD watcher.sh /

ENTRYPOINT ["/watcher.sh"]
