# Basic Lab Environment to learn Ansible

This repository provides simple way to start multiple different hosts for
future use with Ansible. To start using just run:

    vagrant up

This will build and run systemd-enabled Docker containers to act as VMs
provision initial host coniguration on each container and generate Ansible
inventory file that will be used for future Ansible invocations. Here you can
see an example of this process:

[![asciicast](https://asciinema.org/a/z5asYPIoZxOPXXNsLf87b4ujU.svg)](https://asciinema.org/a/z5asYPIoZxOPXXNsLf87b4ujU)

## TODO:

 * Download Vagrant's public key once
