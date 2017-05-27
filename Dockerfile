FROM zeroc0d3lab/centos-base-workspace:latest
MAINTAINER ZeroC0D3 Team <zeroc0d3.team@gmail.com>

#-----------------------------------------------------------------------------
# Set PORT Docker Container
#-----------------------------------------------------------------------------
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8501 8600 8600/udp

#-----------------------------------------------------------------------------
# Set Volume Consul
#-----------------------------------------------------------------------------
VOLUME ["/var/lib/consul"]

#-----------------------------------------------------------------------------
# Check Docker Container
#-----------------------------------------------------------------------------
HEALTHCHECK CMD /etc/cont-consul/check || exit 1
# HEALTHCHECK CMD [ $(curl -sI -w '%{http_code}' --out /dev/null http://localhost:8500/v1/agent/self) == "200" ] || exit 1

## NOTE:
## *) Run vim then >> :PluginInstall
## *) Update plugin vim (vundle) >> :PluginUpdate
