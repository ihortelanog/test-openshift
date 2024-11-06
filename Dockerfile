FROM registry.access.redhat.com/ubi9/ubi-minimal:latest
LABEL org.opencontainers.image.authors="root@example.com>"
LABEL version="1.0.0"
LABEL description="Alert forwarder for Prometheus/Alertmanager alerts to Splunk developyed by CaaS(XXXXXXX)"

RUN microdnf install -y python3 python3-pip

#COPY certs/ /etc/pki/ca-trust/source/anchors

COPY requirements.txt /tmp/requirements.txt

RUN update-ca-trust extract
#ENV PIP_INDEX_URL='XXX'
RUN python3 -m pip install -r /tmp/requirements.txt
WORKDIR /app/forwarder
COPY wsgi.py /app/forwarder
ENV PYTHONUNBUFFERED=0
ENV WEBHOOKPORT=9091
ENTRYPOINT gunicorn --bind 0.0.0.0:${WEBHOOKPORT} --access-logfile "-" wsgi
