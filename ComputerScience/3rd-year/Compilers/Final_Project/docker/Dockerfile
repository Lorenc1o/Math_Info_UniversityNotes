FROM ubuntu:18.04

RUN useradd -ms /bin/bash alumno \
    && apt-get update \
    && apt-get install -y apt-utils binutils gdb gcc make \
                          libreadline-dev libseccomp-dev python3 python3-pexpect python3-pip \
                          curl git emacs-nox locales screen tmux vim wget flex bison sudo spim \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && python3 -m pip install pip --upgrade \
    && pip install gdbgui --upgrade \
    && locale-gen es_ES.UTF-8

ENV LANG es_ES.UTF-8
ENV LC_ALL es_ES.UTF-8

VOLUME ["/home/alumno"]
USER "alumno"
WORKDIR "/home/alumno"
ENTRYPOINT "/bin/bash"
