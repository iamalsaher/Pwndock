FROM ubuntu:tag

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt -y install --no-install-recommends locales strace ltrace patchelf socat gdb git curl ruby-full python-dev python-pip python3-dev python3-pip libc6-dbg libc6-dbg:i386 cmake gcc g++ pkg-config libglib2.0-dev nano\
    && rm -rf /var/lib/apt/lists/* \
    && apt clean

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN python3 -m pip install --upgrade pip \
    && python2 -m pip install --upgrade pip \
    && python3 -m pip install setuptools \
    && python2 -m pip install setuptools \
    && pip install --upgrade pwntools \
    && pip3 install ropper \
    && gem install one_gadget

RUN cd /tmp && curl https://raw.githubusercontent.com/hugsy/stuff/master/update-trinity.sh | sed --expression='s/sudo //g' | bash && ldconfig

RUN pip3 install keystone-engine \
    && mkdir -p $HOME/gef \
    && cd $HOME/gef \
    && curl -L https://github.com/hugsy/gef/raw/master/gef.py > gef.py \
    && curl -L https://github.com/iamalsaher/xploit-template/raw/master/skel.py > skel.py \
    && echo "source $HOME/gef/gef.py" > gdbgef \
    && echo "source $HOME/gef/skel.py" >> gdbgef \
    && echo "alias gdb='gdb -q'" >> ~/.bashrc\
    && echo "alias gef='gdb -nx -ix $HOME/gef/gdbgef'" >> ~/.bashrc

RUN apt remove pkg-config libglib2.0-dev git \
    && rm -rf /var/lib/apt/lists/* \
    && apt clean

RUN echo 'export PS1="[\[\e[34m\]\u\[\e[0m\]@\[\e[33m\]\H\[\e[0m\]:\w]\$ "' >> /root/.bashrc

RUN mkdir /challenge
WORKDIR /challenge
