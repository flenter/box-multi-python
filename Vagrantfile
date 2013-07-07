Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.berkshelf.enabled = true

  # Port forward for wercker (3000) and perceptor (4000)
  config.vm.network :forwarded_port, guest: 3000, host: 3000, auto_correct: true
  config.vm.network :forwarded_port, guest: 4000, host: 4000, auto_correct: true
  config.vm.network :forwarded_port, guest: 15672, host: 15672, auto_correct: true

  # VirtualBox specific customizations
  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", ENV['WERCKER_DEVBOX_MEMORY'] || 1024]
  end

  # Make sure Chef 10.20.0 is installed
  config.vm.provision :shell do |sh|
    sh.inline = <<-EOF
      if [ -f "/home/vagrant/.chef-10.20.0-installed" ]
      then
        echo "Chef 10.20.0 already installed"
      else
        sudo apt-get update
        sudo apt-get install build-essential -y
        gem install chef --no-ri --no-rdoc --no-user-install -v 10.20.0
        touch /home/vagrant/.chef-10.20.0-installed
      fi
    EOF
  end

  # Do the actual provisioning using chef solo
  config.vm.provision :chef_solo do |chef|
    chef.json = {
      :wercker_devbox => {
        :editor => ENV['WERCKER_DEVBOX_EDITOR'],
        :use_supervisor => ENV['WERCKER_DEVBOX_SUPERVISOR'] == 'true',
        :no_bin_links => ENV['WERCKER_DEVBOX_NOBINLINKS'] == 'true'
      }
    }

    chef.add_recipe('apt')
    chef.add_recipe('build-essential')
    chef.add_recipe('python::source')
    chef.add_recipe("multi-python")
    # chef
    # chef.add_recipe('python::pip')
    # chef.add_recipe('nodeenv')
    # chef.add_recipe('mongodb-10gen::single')
    # chef.add_recipe('rabbitmq::mgmt_console')
    # chef.add_recipe('wercker-develop')
    # chef.add_recipe('wercker-develop::wercker-perceptor')
    # chef.add_recipe('wercker-develop::wercker-pool')
    # chef.add_recipe('wercker-develop::wercker-sentinel')
    # chef.add_recipe('wercker-develop::wercker-web')
  end
end
