#!/bin/bash

docker run -d \
  --restart=always \
  --name f5Rancher \
  -p 10.1.20.50:80:80 -p 10.1.20.50:443:443 \
  -v ~/dockerhost-storage/rancher:/var/lib/rancher \
  rancher/rancher:latest

docker run -d \
    -p 10.1.20.30:5000:5000 \
    --restart=always \
    --name f5Registry \
    -v /home/ubuntu/dockerhost-storage/registry/ca-certificates:/certs \
    -v /home/ubuntu/dockerhost-storage/registry/var-lib-registry:/var/lib/registry \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt \
    -e REGISTRY_HTTP_TLS_KEY=/certs/registry.key \
    -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 \
    registry:2
    
docker run -d \
  --restart=always \
  --name f5ELK \
  -p 10.1.20.20:9200:9200 -p 10.1.20.20:5601:5601 -p 10.1.20.20:5144:5144 \
  -v /home/ubuntu/dockerhost-storage/elk/logstash/conf.d:/etc/logstash/conf.d \
  -v /home/ubuntu/dockerhost-storage/elk/elasticsearch:/var/lib/elasticsearch \
  sebp/elk:740

docker run -d \
  --hostname gitlab.f5-udf.com \
  --publish 10.1.20.80:443:443 --publish 10.1.20.80:80:80 --publish 10.1.20.80:2222:22 \
  --name f5Gitlab \
  --restart always \
  --volume /dockerhost-storage/gitlab/config:/etc/gitlab \
  --volume /dockerhost-storage/gitlab/logs:/var/log/gitlab \
  --volume /dockerhost-storage/gitlab/data:/var/opt/gitlab \
  gitlab/gitlab-ce:latest

docker run -d \
        --restart=always \
        --name f5Grafana \
        --network monitoring-net \
        -p 10.1.20.20:3000:3000 \
        -v /home/ubuntu/dockerhost-storage/grafana:/var/lib/grafana \
        grafana/grafana:latest

docker run -d \
        --restart=always \
        -u 1000:1000 \
        --name f5Prometheus \
        --network monitoring-net  \
        -p 10.1.20.20:9090:9090 \
        -v /home/ubuntu/dockerhost-storage/prometheus/config/prometheus.yml:/etc/prometheus/prometheus.yml \
        -v /home/ubuntu/dockerhost-storage/prometheus/data:/prometheus \
        prom/prometheus

docker run -d \
  --name f5Graphite \
  --restart=always \
  --network monitoring-net \
  -p 10.1.20.20:80:80 \
  -p 10.1.20.20:8080:8080 \
  -p 10.1.20.20:2003-2004:2003-2004 \
  -p 10.1.20.20:2013-2014:2013-2014 \
  -p 10.1.20.20:2023-2024:2023-2024 \
  -p 10.1.20.20:8125:8125/udp \
  -p 10.1.20.20:8125:8125/tcp \
  -p 10.1.1.4:8125:8125/udp \
  -p 10.1.1.4:8125:8125/tcp \
  -p 10.1.20.20:8126:8126 \
  -p 10.1.1.4:8126:8126 \
  -v /home/ubuntu/dockerhost-storage/graphite/conf:/opt/graphite/conf \
  -v /home/ubuntu/dockerhost-storage/graphite/data:/opt/graphite/storage \
  -v /home/ubuntu/dockerhost-storage/graphite/statsd-config:/opt/statsd/config \
  graphiteapp/graphite-statsd

  docker run -d \
        --name f5Jenkins \
        --restart=always \
        -p 10.1.20.25:80:8080 \
        -p 10.1.20.25:50000:50000 \
        -v /home/ubuntu/dockerhost-storage/jenkins:/var/jenkins_home \
        jenkins/jenkins:lts
