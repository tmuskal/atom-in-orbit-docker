from nodesource/fedora24:6.3.1
RUN yum clean all
RUN yum install -y yum-plugin-ovl
RUN yum install -y \
    make \
    gcc \
    gcc-c++ \
    glibc-devel \
    git-core \
    libsecret-devel \
    rpmdevtools \
    libgnome-keyring-devel libgconf-2.so.4 libgtk-x11-2.0.so.0
RUN yum -y groupinstall "X Software Development"
RUN git clone https://github.com/atom/atom.git /atom

WORKDIR /atom
RUN npm config set python /usr/bin/python2 -g
RUN git checkout 3a9fafc201dd6170a213d920a6eb82bec0d65b12
# RUN script/bootstrap
# RUN npm install
RUN script/build
WORKDIR /
RUN git clone https://github.com/facebook-atom/atom-in-orbit.git /atom-in-orbit
WORKDIR /atom-in-orbit
RUN echo '{"ATOM_SRC": "/atom"}' > /atom-in-orbit/config.local.json
RUN npm install --only=dev
ADD ./build.js /atom-in-orbit/scripts/build.js
ADD ./compile-cache.js.patch /atom-in-orbit/scripts/patches/src/compile-cache.js.patch
RUN npm run build
ADD . /app
WORKDIR /app
RUN npm install
EXPOSE 3000
ENV servePath=/
CMD ["npm","start"]

