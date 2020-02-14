jollyroger.ping: Install ping from iputils
==========================================

Simple role to install ping package. It could be useful to check network
connectivity between hosts in your environment. This will catch incorrect
networking setup on early stages. Idea to write this role came after an hour
of testing lab environment just to understant I have an old version of Vagrant
that does support docker networking but at the same time does not inform you
about unsupported configuration.

Requirements
------------

None.

Role Variables
--------------

None.

Dependencies
------------

None.

Example Playbook
----------------

To check network connectivity after vagrant started all hosts you can run a
simple playbook:

    - hosts: servers
      roles:
         - ping
      tasks:
        - name: Test connection to random host in a play
          command: "ping -c1 {{ play_hosts|random }}"
          changed_when: False

License
-------

Apache-2.0
