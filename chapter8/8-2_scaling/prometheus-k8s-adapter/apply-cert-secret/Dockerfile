FROM alpine
RUN apk add --no-cache openssl && \
	wget https://storage.googleapis.com/kubernetes-release/release/$(wget -qO - https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
	chmod +x kubectl
COPY gencert.sh .

CMD ["/gencert.sh"]