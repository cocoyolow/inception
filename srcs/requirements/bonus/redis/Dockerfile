FROM debian:12

RUN apt update && \
    apt install -y redis-server && \
    apt clean

ENTRYPOINT ["redis-server", "--bind", "0.0.0.0", "--maxmemory", "20mb", "--maxmemory-policy", "allkeys-lru", "--protected-mode", "no"]