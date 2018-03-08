VAGRANT_HOME="/home/vagrant/"

Vagrant.configure("2") do |config|
  # config.vm.box = "debian/jessie64"
  config.vm.box = "debian/stretch64"
  
  # Change Keyboard language to french(azerty)
  config.vm.provision "shell", inline: "cp /vagrant/configuration/keyboard /etc/default/keyboard"
  config.vm.provision "shell", inline: "service keyboard-setup restart"
  config.vm.provision "shell", inline: "udevadm trigger --subsystem-match=input --action=change"
  
  # Change locale language to french
  config.vm.provision "frenchX", type: "shell", inline: <<-SHELL 
	localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
	update-locale LANG=fr_FR.UTF-8 LANGUAGE=fr_FR
  SHELL
  
  # ssh configuration
  config.vm.provision "file", source: "~/.ssh", destination: "/home/vagrant/.ssh"
  config.vm.provision "shell", inline: "chmod 644 -R /home/vagrant/.ssh"
  
  # Prepare git configuration
  config.vm.provision "shell", inline: "cp /vagrant/configuration/.gitconfig /home/vagrant/.gitconfig"
  config.vm.provision "shell", inline: "chmod 755 /home/vagrant/.gitconfig"
   
  # Add Development tools
  config.vm.provision "installTools", type: "shell", inline: <<-SHELL
	 export DEBIAN_FRONTEND=noninteractive
	 echo -e 'Dpkg::Progress-Fancy "1";\nAPT::Color "1";' > /etc/apt/apt.conf.d/99progressbar
	 sudo apt-get -y -q install curl
     curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
	 curl -s https://packages.microsoft.com/keys/microsoft.asc --progress-bar | gpg --dearmor > microsoft.gpg
	 sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
	 sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
	 sudo apt-get -y -q update # >/dev/null 2>&1
	 sudo apt-get -y -q install nodejs libxss1 code git chromium chromium-l10n # >/dev/null 2>&1
	 #### XFCE ###
	 # sudo apt-get -y -q install xfce4 
	 #### LXQT ###
	 # sudo apt-get -y -q lxqt-core 
	 ### OTHERS ###
	 sudo apt-get -y -qq install xfonts-base xserver-xorg-input-all xinit xserver-xorg xserver-xorg-video-all
	 # sudo apt-get -y -qq install openbox obconf obmenu
	 sudo apt-get -y -qq install --no-install-recommends lxde-core
	 ### CLEAN ###
	 sudo apt-get autoremove -y
   SHELL

  config.vm.provision "shell", inline: "setxkbmap fr"
  
  # User configuration 
  config.vm.provision "addUser", type: "shell",  inline: <<-SHELL
	# Add user in sudoer
	adduser vagrant  sudo >/dev/null 2>&1
	# Create Workspace
	mkdir /home/vagrant/workspace
	chown vagrant:vagrant /home/vagrant/workspace
	# Start X at connexion
	[ -f ~/.profile ] || touch ~/.profile
	echo "startx" >> /home/vagrant/.profile
  SHELL
  
  # Declare provider
  config.vm.provider 'virtualbox' do |vb|
	vb.gui = true
	vb.memory = '1024'
    vb.cpus = '2'
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
  end
end
