FROM python:3.7-alpine

EXPOSE 5000
WORKDIR /app
CMD ["/usr/local/bin/python", "app.py"]

COPY requirements.txt .
RUN pip install -r requirements.txt
COPY app.py .

ENV REDIS_HOST=localhost
ENV REDIS_PORT=6379
ENV REDIS_DB=0
