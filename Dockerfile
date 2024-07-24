FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip3 install flask

WORKDIR /app

COPY app/ /app

CMD ["python3", "app.py"]

