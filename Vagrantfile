BASE_IMAGE = "fewpixels/Ubuntu20base"
PROVIDER = "virtualbox"
VERSION = "0.2"

Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define "nameserver" do |server|
    server.vm.box = BASE_IMAGE
    server.vm.box_version = VERSION
    #server.vm.hostname = "nameserver"
    server.vm.network "private_network", ip: "10.0.1.2"
    server.vm.provider PROVIDER do |vb|
      vb.name = "server"
      vb.cpus = 1
      vb.memory = 512
      vb.linked_clone = true
    end
    server.vm.provision "shell", path: "provisioners/scripts/bootstrap.sh"
   end

end