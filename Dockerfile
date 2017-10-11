FROM zeroc0d3lab/centos-base:latest
MAINTAINER ZeroC0D3 Team <zeroc0d3.team@gmail.com>

#-----------------------------------------------------------------------------
# Set Environment
#-----------------------------------------------------------------------------
ENV CONSULTEMPLATE_VERSION=0.19.0

#-----------------------------------------------------------------------------
# Set Group & User for 'consul'
#-----------------------------------------------------------------------------
RUN mkdir -p /var/lib/consul \
    && groupadd consul \
    && useradd -r -g consul consul \
    && usermod -aG consul consul \
    && chown -R consul:consul /var/lib/consul

#-----------------------------------------------------------------------------
# Install Consul Template Library
#-----------------------------------------------------------------------------
RUN curl -sSL https://releases.hashicorp.com/consul-template/${CONSULTEMPLATE_VERSION}/consul-template_${CONSULTEMPLATE_VERSION}_linux_amd64.zip -o /tmp/consul-template.zip \
    && unzip /tmp/consul-template.zip -d /bin \
    && rm -f /tmp/consul-template.zip

#-----------------------------------------------------------------------------
# Set PORT Docker Container
#-----------------------------------------------------------------------------
EXPOSE 1234

#-----------------------------------------------------------------------------
# Setup TrueColors (Terminal)
#-----------------------------------------------------------------------------
COPY ./rootfs/root/colors/24-bit-color.sh /root/colors/24-bit-color.sh
RUN chmod a+x /root/colors/24-bit-color.sh \
    ./root/colors/24-bit-color.sh

#-----------------------------------------------------------------------------
# Finalize (reconfigure)
#-----------------------------------------------------------------------------
COPY rootfs/ /

#-----------------------------------------------------------------------------
# Check Docker Container
#-----------------------------------------------------------------------------
HEALTHCHECK CMD /etc/cont-consul/check || exit 1
# HEALTHCHECK CMD [ $(curl -sI -w '%{http_code}' --out /dev/null http://localhost:8500/v1/agent/self) == "200" ] || exit 1