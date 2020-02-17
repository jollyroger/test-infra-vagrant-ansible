# ex: ft=ruby
require "open-uri"

# Use docker as the backend
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'

# Prevent parallel execution
#ENV['VAGRANT_NO_PARALLEL'] = 'yes'

vagrant_pubkey_url = "https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub"
vagrant_pubkey_name = ".vagrant/vagrant.pub"

kinds   = [ "app", "db", "web" ]

images = [
    {
      distribution: "debian",
      dockerfile: "debian10-systemd.Dockerfile",
      tag: "local-debian10/systemd",
      python_interpreter: "/usr/bin/python3"
    }, {
      distribution: "ubuntu",
      dockerfile: "ubuntu1804-systemd.Dockerfile",
      tag: "local-ubuntu1804/systemd",
      python_interpreter: "/usr/bin/python3"
    }, {
      distribution: "centos7",
      dockerfile: "centos7-systemd.Dockerfile",
      tag: "local-centos7/systemd",
      python_interpreter: "/usr/bin/python2.7"
    }, {
      distribution: "centos8",
      dockerfile: "centos8-systemd.Dockerfile",
      tag: "local-centos8/systemd",
      python_interpreter: "/usr/bin/python3"
    }
]

Vagrant.configure("2") do |config|

  # Check and download vagrant pubkey to include in the Docker images
  config.trigger.before :up do |trigger|
    trigger.name = "Prepare insecure Vagrant SSH public key"
    trigger.ruby do |env, machine|
      vagrant_pubkey_url = "https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub"
      vagrant_pubkey_name = ".vagrant/vagrant.pub"

      unless File.file?(vagrant_pubkey_name)
        trigger.info = "Vagrant's insecure SSH public key is not present. Downloading..."
        open(vagrant_pubkey_url) do |pubkey|
          File.open(vagrant_pubkey_name, "wb") do |pubkey_file|
            pubkey_file.write(pubkey.read)
            trigger.info = "Download complete. Saved key to #{vagrant_pubkey_name}"
          end
        end
      end
    end
  end

  # declare hashes to feed to Ansible inventory
  ansible_groups = {}
  ansible_host_vars = {}


  # Start multiple instances according to the instances matrix. The names will
  # be in format <kind><count>-<distribution>, for example app1-debian
  kinds.each do |server_type|
    ansible_groups[server_type] = Array.new
    (1..images.length).zip(images).each do |index, image|
      if ! ansible_groups[image[:distribution]]
        ansible_groups[image[:distribution]] = Array.new
      end

      node_name = "#{server_type}#{index}-#{image[:distribution]}"

      ansible_groups[server_type] << node_name
      ansible_groups[image[:distribution]] << node_name
      ansible_host_vars[node_name] = {
          "ansible_python_interpreter" => image[:python_interpreter]
      }

      config.vm.define "#{node_name}" do |node|
        node.vm.network :private_network, type: "dhcp"
        node.vm.provider "docker" do |docker|
          docker.name = node_name
          docker.build_dir = "."
          docker.has_ssh = true
          docker.dockerfile = "dockerfiles/#{image[:dockerfile]}"
          docker.create_args = ["--rm", "--privileged", "-v", "/sys/fs/cgroup:/sys/fs/cgroup:ro"]
          docker.build_args  = ["-t", "#{image[:tag]}"]
        end
      end
    end
  end

  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "init.yml"
    ansible.groups = ansible_groups
    ansible.host_vars = ansible_host_vars
  end
end
