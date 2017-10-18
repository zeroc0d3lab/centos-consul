FROM zeroc0d3lab/centos-base:latest
MAINTAINER ZeroC0D3 Team <zeroc0d3.team@gmail.com>

#-----------------------------------------------------------------------------
# Set Environment
#-----------------------------------------------------------------------------
ENV CONSUL_VERSION=1.0.0 \
    CONSULTEMPLATE_VERSION=0.19.3

#-----------------------------------------------------------------------------
# Set Group & User for 'consul'
#-----------------------------------------------------------------------------
RUN mkdir -p /var/lib/consul \
    && groupadd consul \
    && useradd -r -g consul consul \
    && usermod -aG consul consul \
    && chown -R consul:consul /var/lib/consul

#-----------------------------------------------------------------------------
# Install Consul Library
#-----------------------------------------------------------------------------
RUN curl -sSL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -o /opt/consul.zip \
    && unzip /opt/consul.zip -d /bin \
    && rm /opt/consul.zip \
    && mkdir -p /var/lib/consului \
    && curl -sSL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_web_ui.zip -o /opt/consului.zip \
    && unzip /opt/consului.zip -d /var/lib/consului \
    && rm /opt/consului.zip \
    && curl -sSL https://releases.hashicorp.com/consul-template/${CONSULTEMPLATE_VERSION}/consul-template_${CONSULTEMPLATE_VERSION}_linux_amd64.zip -o /opt/consul-template.zip \
    && unzip /opt/consul-template.zip -d /bin \
    && rm -f /opt/consul-template.zip

#-----------------------------------------------------------------------------
# Setup TrueColors (Terminal)
#-----------------------------------------------------------------------------
COPY ./rootfs/root/colors/24-bit-color.sh /opt/24-bit-color.sh
RUN chmod a+x /opt/24-bit-color.sh; sync \
    && sudo /bin/sh /opt/24-bit-color.sh

#-----------------------------------------------------------------------------
# Set PORT Docker Container
#-----------------------------------------------------------------------------
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8501 8600 8600/udp

#-----------------------------------------------------------------------------
# Set Volume Docker Consul
#-----------------------------------------------------------------------------
VOLUME ["/var/lib/consul"]

#-----------------------------------------------------------------------------
# Finalize (reconfigure)
#-----------------------------------------------------------------------------
COPY rootfs/ /

#-----------------------------------------------------------------------------
# Run Init Docker Container
#-----------------------------------------------------------------------------
ENTRYPOINT ["/init"]
CMD []

#-----------------------------------------------------------------------------
# Check Docker Container
#-----------------------------------------------------------------------------
HEALTHCHECK CMD /etc/cont-consul/check || exit 1
# HEALTHCHECK CMD [ $(curl -sI -w '%{http_code}' --out /dev/null http://localhost:8500/v1/agent/self) == "200" ] || exit 1
