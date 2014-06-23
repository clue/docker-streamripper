FROM ubuntu
MAINTAINER Christian Lück <christian@lueck.tv>

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
	streamripper

RUN useradd -m -d /home/streamripper streamripper
USER streamripper
WORKDIR /home/streamripper

# expose relay port
EXPOSE 8000

ADD run.sh /run.sh
ENTRYPOINT ["/run.sh"]
VOLUME /home/streamripper
