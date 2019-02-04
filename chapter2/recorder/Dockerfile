FROM python:3.7-alpine

WORKDIR /app
CMD ["/usr/local/bin/python", "process.py"]

COPY requirements.txt .
RUN apk add --no-cache \
			gcc \
			libffi-dev \
			musl-dev \
			openssl-dev \
			python3-dev \
 && pip install -r requirements.txt \
 && apk del \
 		gcc \
		libffi-dev \
		musl-dev \
		openssl-dev \
		python3-dev

COPY process.py .

ENV REDIS_HOST=localhost
ENV REDIS_PORT=6379
ENV REDIS_DB=0
ENV MYSQL_HOST=localhost
ENV MYSQL_PORT=3306
