Vagrant.configure("2") do |config|
  config.vm.box = "centos65"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-65-i386-virtualbox-puppet.box"
  config.vm.network "private_network", ip: "192.168.33.10"
  
  config.vm.synced_folder "./www", "/var/www", id: "vagrant-www", :nfs => true
  
  config.vm.provider :virtualbox do |virtualbox|
      virtualbox.customize ["modifyvm", :id, "--memory", "640"]
  end
  
  config.vm.provision :puppet do |puppet|
      puppet.facter = {
        "ssh_username" => "vagrant"
      }
    
      puppet.manifests_path = "vagrant/puppet/manifests"
      puppet.module_path = "vagrant/puppet/modules"
      puppet.manifest_file = "init.pp"
      puppet.options = ["--verbose",]
  end
end