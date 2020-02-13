jollyroger.openssh: Manage your OpenSSH server
==============================================

This role is derived as a lab by using robertdebock.openssh role as an example
with some changes to get better variable precedence in a few edge cases e.g.
running server by another user. See [this post][1] for possible cases.

 [1]: https://serverfault.com/questions/344295

Requirements
------------

You might want to install `python-apt` or `python3-apt` packages on a target
system beforehand to avoid warnings when run with `--check` before first run
but the `package` module will happily install this for you and this will not
affect your setup in subsequent runs.

Role Variables
--------------

These are defined as the defaults and could be easily overriden if necessary:

* `openssh_run_directory` - directory where sshd's PID file is created;
  defaults to distribution-specific path
* `openssh_run_directory_mode` - `"0755"`
* `openssh_run_directory_owner` - `root`
* `openssh_run_directory_group` - `root`
* `openssh_configuration_file` - `/etc/ssh/sshd_config`
* `openssh_configuration_file_mode` - OpenSSH configuration file permissions;
  default to distribution-specific values
* `openssh_configuration_file_owner` - `root`
* `openssh_configuration_file_group` - `root`
* `openssh_service` - `sshd`

Dependencies
------------

None.

Example Playbook
----------------

In most cases this playbook does not require additional configuration. One of
the interesting applications could be writing an `openssh-user` role that would
depend on this one by overriding configuration file settings and paths to make
this server run as non-root. 

License
-------

Apache-2.0
