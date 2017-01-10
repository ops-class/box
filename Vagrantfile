VAGRANT_COMMAND = ARGV[0]

Vagrant.configure(2) do |config|

  config.vm.box = "bento/ubuntu-16.04"
  config.vm.hostname = "zion"

  if Vagrant.has_plugin?("vagrant-timezone")
    config.timezone.value = :host
  end

  config.vm.provider "virtualbox" do |v|
    v.name = "ops-class.org 1.0"
    v.cpus = "1"
    v.memory = "512"
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
    v.customize ["modifyvm", :id, "--usb", "off"]
    v.customize ["modifyvm", :id, "--usbehci", "off"]
    v.customize ["modifyvm", :id, "--cableconnected1", "on"]
  end

  config.vm.provision "file", source: "bashrc", destination: "/tmp/bashrc"
  config.vm.provision "shell",  path: "provision.sh"

  if VAGRANT_COMMAND == "ssh"
    config.ssh.username = "trinity"
  end
end

# vim: ts=2:sw=2:et:ft=ruby