FROM ubuntu:xenial

RUN apt-get update; apt-get install -y \
            python-matplotlib python-serial python-wxgtk3.0 python-wxtools python-lxml \
            python-scipy python-opencv ccache python-pip python-pexpect \
            python-setuptools gcc gawk make git curl g++ python-serial python-numpy python-pyparsing realpath \
            libxml2-dev libxslt-dev python-dev python-pygame; \
    pip2 install wheel setuptools catkin_pkg future dronekit lxml --upgrade; \
    pip2 install -U pymavlink MAVProxy; \
    adduser --system --home /home/gopher --shell /bin/bash --group --disabled-password gopher; \
    usermod -a -G www-data gopher; \
    echo "export PATH=$PATH:$HOME/ardupilot/Tools/autotest" >> /home/gopher/.bashrc; \
    echo "export PATH=/usr/lib/ccache:$PATH" >> /home/gopher/.bashrc; 


USER gopher
WORKDIR /home/gopher
RUN git clone https://github.com/ArduPilot/ardupilot.git; \
    cd ardupilot; \
    git submodule update --init --recursive;

CMD ["/bin/bash"]
