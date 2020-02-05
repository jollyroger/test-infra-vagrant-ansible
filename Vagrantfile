Vagrant.configure("2") do |config|
    config.vm.define "web1" do |web1|
      web1.vm.box = "generic/debian10"
    end

    config.vm.define "web2" do |web2|
      web2.vm.box = "generic/ubuntu1804"
    end

    config.vm.define "web3" do |web3|
      web3.vm.box = "generic/centos7"
    end

    config.vm.define "app1" do |app1|
      app1.vm.box = "generic/debian10"
    end

    config.vm.define "app2" do |app2|
      app2.vm.box = "generic/debian10"
    end

    config.vm.define "app3" do |app3|
      app3.vm.box = "generic/centos7"
    end

    config.vm.define "db1" do |db1|
      db1.vm.box = "generic/debian10"
    end

    config.vm.define "db2" do |db2|
      db2.vm.box = "generic/ubuntu1804"
    end

    config.vm.define "db3" do |db3|
      db3.vm.box = "generic/centos7"
    end

  config.vm.provider "hyperv" do |hyperv|
    hyperv.memory = 512
    hyperv.cpus = 1
  end

  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "site.yml"
    ansible.groups = {
      "web" => ["web*"],
      "app" => ["app*"],
      "db"  => ["db*"],
      "debian" => ["*1"],
      "ubuntu" => ["*2"],
      "centos" => ["*3"]
    }
  end
end
