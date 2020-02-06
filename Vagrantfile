Vagrant.configure("2") do |config|
  ansible_groups = Hash.new
  kinds   = ["app", "db", "web"]
  distros = ["debian", "ubuntu", "centos"]
  images  = ["generic/debian10", "generic/ubuntu1804", "generic/centos7"]

  if distros.length != images.length
    raise Exception.new "Config error: There should be equal number of elements in distros and images"
  end

  kinds.each do |server_type|
    ansible_groups[server_type] = Array.new
    (1..distros.length).zip(distros, images).each do |index, distro, image|
      if ! ansible_groups[distro]
        ansible_groups[distro] = Array.new
      end

      node_name = "#{server_type}#{index}-#{distro}"

      ansible_groups[server_type] << node_name
      ansible_groups[distro] << node_name

      config.vm.define node_name do |node|
        node.vm.box = "#{image}"
      end
    end
  end

  config.vm.provider "hyperv" do |hyperv|
    hyperv.memory = 512
    hyperv.cpus = 1
  end

  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "site.yml"
    ansible.groups = ansible_groups
  end
end
