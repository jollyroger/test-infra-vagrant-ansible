FROM centos:7

ENV container docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*; \
    rm -f /lib/tmpfiles.d/systemd-nologin.conf;

RUN yum -y install openssh-server sudo rsyslog python3; \
    yum clean all ; \
    echo "Enabling openssh and rsyslog services:" ; \
    systemctl enable sshd.service ; \
    systemctl enable rsyslog.service ; \
    sed -i 's/^#*UseDNS.*$/UseDNS no/' /etc/ssh/sshd_config ; \
    echo "Setting up vagrant user" ; \
    adduser -p '$1$5EgZJmhQ$xM4l4z53kObremUuivxzX1' vagrant ; \
    mkdir ~vagrant/.ssh ; chmod 0700 ~vagrant/.ssh ; \
    echo "vagrant ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers ;

COPY .vagrant/vagrant.pub /home/vagrant/.ssh

RUN mv ~vagrant/.ssh/vagrant.pub ~vagrant/.ssh/authorized_keys ; \
    chmod 600 ~vagrant/.ssh/authorized_keys ; \
    chown -R vagrant: ~vagrant/.ssh

EXPOSE 22

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
