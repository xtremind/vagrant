Vagrant.configure("2") do |config|
  config.vm.box = "debian/jessie64"

  # declare new user
  class Username
        def to_s
            print "Virtual machine needs you proxy user and password.\n"
            print "Username: " 
            STDIN.gets.chomp
        end
    end
    
    class Password
        def to_s
            begin
            system 'stty -echo'
            print "Password: "
            pass = URI.escape(STDIN.gets.chomp)
            ensure
            system 'stty echo'
            end
            pass
        end
    end
	
	
  class Email
        def to_s
            print "\nEmail: " 
            STDIN.gets.chomp
        end
    end
  
  # Change Keyboard language to french(azerty)
  config.vm.provision "file", source: "./configuration/keyboard", destination: "/tmp/keyboard"
  config.vm.provision "shell", inline: "mv /tmp/keyboard /etc/default/keyboard"
  config.vm.provision "shell", inline: "service keyboard-setup restart"
  
  # Change locale language to french
  config.vm.provision "frenchX", type: "shell", inline: <<-SHELL 
	localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
	update-locale LANG=fr_FR.UTF-8 LANGUAGE=fr_FR
  SHELL

  # Prepare panel personalization
  config.vm.provision "shell", inline: "mkdir /tmp/panel"
  config.vm.provision "shell", inline: "chmod 777 -R /tmp/panel"
  config.vm.provision "file", source: "./panel", destination: "/tmp/panel"
  
  # ssh configuration
  config.vm.provision "shell", inline: "mkdir /tmp/ssh"
  config.vm.provision "shell", inline: "chmod 777 -R /tmp/ssh"
  config.vm.provision "file", source: "~/.ssh", destination: "/tmp/ssh"
  
  # Prepare git configuration
  config.vm.provision "file", source: "./configuration/.gitconfig", destination: "/tmp/.gitconfig"
  config.vm.provision "shell", inline: "chmod 777 /tmp/.gitconfig"
   
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
	 sudo apt-get -y -q install nodejs libxss1 code git xfce4 chromium chromium-l10n # >/dev/null 2>&1
   SHELL

  # User Manager
  config.vm.provision "addUser", type: "shell",  env: {"USERNAME" => Username.new, "PASSWORD" => Password.new, "EMAIL" => Email.new}, inline: <<-SHELL
	# Create User
	adduser $USERNAME >/dev/null 2>&1
	echo -e "$USERNAME:$PASSWORD" | chpasswd >/dev/null 2>&1
	# Add user in sudoer
	adduser $USERNAME  sudo >/dev/null 2>&1
	# Create Workspace
	mkdir /home/$USERNAME/workspace
	# Create SSH
	mkdir /home/$USERNAME/.ssh
	cp -R /tmp/ssh /home/$USERNAME/.ssh
	# Start X at connexion
	[ -f ~/.profile ] || touch ~/.profile
	echo "startx" >> /home/$USERNAME/.profile
	# configure launcher
	# cp /tmp/panel/* /home/$USERNAME/
	# configure git
	cp /tmp/.gitconfig /home/$USERNAME/
	echo "	name = $USERNAME" >> /home/$USERNAME/.gitconfig
	echo "	email = $EMAIL" >> /home/$USERNAME/.gitconfig
	chown -R $USERNAME:$USERNAME /home/$USERNAME
  SHELL
  
  #TODO /tmp not needed since /vagrant is a sync folder
  
  # Declare provider
  config.vm.provider 'virtualbox' do |vb|
	vb.gui = true
	vb.memory = '1024'
    vb.cpus = '2'
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
  end
end
