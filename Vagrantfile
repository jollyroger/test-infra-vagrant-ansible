require "open-uri"

Vagrant.configure("2") do |config|

  # Check and download vagrant pubkey to include in the Docker images
  vagrant_pubkey_url = "https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub"
  vagrant_pubkey_name = "./.vagrant/vagrant.pub"

  if File.file?(vagrant_pubkey_name)
    open(vagrant_pubkey_url) do |pubkey|
      File.open(vagrant_pubkey_name, "wb") do |file|
        file.write(pubkey.read)
      end
    end
  end

  # Use docker as the backend
  ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'
  # Prevent parallel execution
  ENV['VAGRANT_NO_PARALLEL'] = 'yes'

  # declare a hash where all containers are put to seed Ansible inventory
  ansible_groups = {}
  ansible_host_vars = {}

  kinds   = [
    "app",
    "db",
    "web"
  ]

  distros = [
    "debian",
    "ubuntu",
    "centos7",
    "centos8"
  ]

  dockerfiles = [
    "debian10-systemd.Dockerfile",
    "ubuntu1804-systemd.Dockerfile",
    "centos7-systemd.Dockerfile",
    "centos8-systemd.Dockerfile"
  ]

  images = [
    "local-debian10/systemd",
    "local-ubuntu1804/systemd",
    "local-centos7/systemd",
    "local-centos8/systemd"
  ]

  if distros.length != images.length or distros.length != dockerfiles.length
    raise Exception.new "Config error: There should be equal number of elements in distros and images"
  end

  # Start multiple instances according to the instances matrix. The names will
  # be in format <kind><count>-<distro>, for example app1-debian
  kinds.each do |server_type|
    ansible_groups[server_type] = Array.new
    (1..distros.length).zip(distros, dockerfiles, images).each do |index, distro, dockerfile, image|
      if ! ansible_groups[distro]
        ansible_groups[distro] = Array.new
      end

      node_name = "#{server_type}#{index}-#{distro}"

      ansible_groups[server_type] << node_name
      ansible_groups[distro] << node_name
      ansible_host_vars[node_name] = { "ansible_python_interpreter" => "/usr/bin/python3" }

      config.vm.define "#{node_name}" do |node|
        node.vm.provider "docker" do |docker|
          docker.name = node_name
          docker.build_dir = "."
          docker.has_ssh = true
          docker.dockerfile = "#{dockerfile}"
          docker.create_args = ["--rm", "--privileged", "-v", "/sys/fs/cgroup:/sys/fs/cgroup:ro"]
          docker.build_args  = ["-t", "#{image}"]
        end
      end
    end
  end

  #print ansible_host_vars

  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "site.yml"
    ansible.groups = ansible_groups
    ansible.host_vars = ansible_host_vars
  end
end
