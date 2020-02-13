FROM debian:10

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y systemd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    /lib/systemd/system/systemd-update-utmp*

COPY generate-ssh-keys.service /etc/systemd/system
COPY generate-ssh-keys /usr/local/bin

RUN apt-get update && apt-get install -y openssh-server openssh-client sudo \
    rsyslog python3-minimal && \
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ; \
    echo "Enabling openssh and rsyslog services:" ; \
    systemctl enable sshd.service ; \
    systemctl enable rsyslog.service ; \
    systemctl enable generate-ssh-keys.service ; \
    sed -i 's/^#*UseDNS.*$/UseDNS no/' /etc/ssh/sshd_config ; \
    rm -v /etc/ssh/ssh_host_* ; \
    echo "Setting up vagrant user" ; \
    useradd -mU -s /bin/bash -p '$1$5EgZJmhQ$xM4l4z53kObremUuivxzX1' vagrant ; \
    mkdir ~vagrant/.ssh ; chmod 0700 ~vagrant/.ssh ; \
    echo "vagrant ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers ;

COPY .vagrant/vagrant.pub /home/vagrant/.ssh

RUN mv ~vagrant/.ssh/vagrant.pub ~vagrant/.ssh/authorized_keys ; \
    chmod 644 ~vagrant/.ssh/authorized_keys ; \
    chown -R vagrant: ~vagrant/.ssh

EXPOSE 22

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/lib/systemd/systemd"]
