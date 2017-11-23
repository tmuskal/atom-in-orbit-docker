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
    libgnome-keyring-devel
RUN yum -y groupinstall "X Software Development"
ENV servePath=/atom-in-orbit
RUN git clone https://github.com/atom/atom.git /atom

WORKDIR /atom
RUN npm config set python /usr/bin/python2 -g
# RUN git checkout f7d3f0210bf6ff1b4193d8a8b8a54c199b561bc2; 
# RUN script/bootstrap
RUN yum install -y libgtk-x11-2.0.so.0
RUN script/build
WORKDIR /
RUN git clone https://github.com/facebook-atom/atom-in-orbit.git /atom-in-orbit.git
WORKDIR /atom-in-orbit
RUN echo '{"ATOM_SRC": "/atom"}' > /atom-in-orbit/config.local.json
RUN npm install
RUN npm run build
ADD . /app
WORKDIR /app
EXPOSE 3000
CMD ["npm","start"]

