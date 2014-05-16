#
# nginx reverse proxy
#

FROM ubuntu
MAINTAINER dusty@clarkda.com

# Update our repositories
RUN apt-get update

# ..
RUN apt-get install supervisor nginx

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord"]