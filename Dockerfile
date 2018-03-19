FROM ubuntu:xenial

ARG VNC_PASSWORD=secret
ENV VNC_PASSWORD=${VNC_PASSWORD} \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update; apt-get install -y \
            libgl1-mesa-glx libgl1-mesa-dri mesa-utils \
            dbus-x11 x11-utils x11vnc xvfb supervisor \
            dwm suckless-tools dmenu stterm \
            python-matplotlib python-serial python-wxgtk3.0 python-wxtools python-lxml \
            python-scipy python-opencv ccache python-pip python-pexpect \
            python-setuptools gcc gawk make git curl g++ python-serial python-numpy python-pyparsing realpath \
            libxml2-dev libxslt-dev python-dev python-pygame; \
    pip2 install wheel setuptools catkin_pkg future dronekit lxml --upgrade; \
    pip2 install -U pymavlink MAVProxy; \
    adduser --system --home /home/gopher --shell /bin/bash --group --disabled-password gopher; \
    usermod -a -G www-data gopher; \
    mkdir -p /etc/supervisor/conf.d; \
    x11vnc -storepasswd $VNC_PASSWORD /etc/vncsecret; \
    chmod 444 /etc/vncsecret; \
    apt-get autoclean; \
    apt-get autoremove; \
    rm -rf /var/lib/apt/lists/*; 

COPY supervisord.conf /etc/supervisor/conf.d
EXPOSE 5900

USER gopher
WORKDIR /home/gopher
RUN echo "export PATH=/usr/lib/ccache:$PATH:/home/gopher/ardupilot/Tools/autotest" >> /home/gopher/.bashrc; \
    git clone https://github.com/ArduPilot/ardupilot.git; \
    cd ardupilot; \
    git submodule update --init --recursive;

CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
