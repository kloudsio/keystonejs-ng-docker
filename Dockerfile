FROM ubuntu:trusty
MAINTAINER William Blankenship <wblankenship@nodesource.com>
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /etc/apt/sources.list.d/mongodb.list
RUN apt-get update
RUN apt-get install -y --force-yes --no-install-recommends apt-transport-https build-essential curl ca-certificates git lsb-release python-all rlwrap mongodb-org
RUN curl https://deb.nodesource.com/node_0.12/pool/main/n/nodejs/nodejs_0.12.4-1nodesource1~trusty1_amd64.deb > node.deb
RUN dpkg -i node.deb 
RUN rm node.deb
RUN npm install -g pangyp pm2
RUN ln -s $(which pangyp) $(dirname $(which pangyp))/node-gyp
RUN npm cache clear
RUN node-gyp configure || echo ""
RUN apt-get update
RUN apt-get upgrade -y --force-yes
VOLUME ["/data/db"]
WORKDIR /data
RUN mongod
WORKDIR /
COPY ./keystonejs-ng-skeleton /keystonejs-ng-skeleton
WORKDIR /keystonejs-ng-skeleton
RUN npm install
ENV NODE_ENV production
WORKDIR /keystonejs-ng-skeleton
CMD ["npm","start"]