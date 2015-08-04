############################################################
# Dockerfile: CentOS7 & Webmin
############################################################
FROM centos:centos6

MAINTAINER CarbonSphere <CarbonSphere@gmail.com>

# Set environment variable
ENV HOME 						/root
ENV TERM 						xterm
ENV ROOTPASSWD					webmin

ADD webmin.repo /etc/yum.repos.d/webmin.repo
ADD http://www.webmin.com/jcameron-key.asc /tmp/jcameron-key.asc

RUN rpm --import /tmp/jcameron-key.asc; \
	yum -y install webmin; 

RUN yum -y install epel-release 
RUN yum -y install supervisor

ADD supervisor/supervisord.conf /etc/supervisord.conf

EXPOSE 10000

CMD /bin/sh /etc/webmin/start && \
	/bin/echo "root:${ROOTPASSWD}" | /usr/sbin/chpasswd && \
	/usr/bin/supervisord -c /etc/supervisord.conf
