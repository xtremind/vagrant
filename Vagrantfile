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
  
  # Change Keyboard language to french(azerty)
  config.vm.provision "file", source: "./keyboard", destination: "/tmp/keyboard"
  config.vm.provision "shell", inline: "mv /tmp/keyboard /etc/default/keyboard"
  config.vm.provision "shell", inline: "service keyboard-setup restart"
  
  # Change locale language to french
  config.vm.provision "frenchX", type: "shell", inline: <<-SHELL 
	localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
	update-locale LANG=fr_FR.UTF-8 LANGUAGE=fr_FR
  SHELL

  # User Manager
  config.vm.provision "addUser", type: "shell",  env: {"USERNAME" => Username.new, "PASSWORD" => Password.new}, inline: <<-SHELL
	# Create User
	adduser $USERNAME >/dev/null 2>&1
	echo -e "$USERNAME:$PASSWORD" | chpasswd >/dev/null 2>&1
	# Add user in sudoer
	adduser $USERNAME  sudo >/dev/null 2>&1
	# Create Workspace
	mkdir /home/$USERNAME/workspace
	chown $USERNAME:$USERNAME /home/$USERNAME/workspace
	# Create SSH
	mkdir /home/$USERNAME/.ssh
	yes | ssh-keygen -b 2048 -t rsa -f /home/$USERNAME/.ssh/id_rsa -q -N ""
	echo
	echo *********************************
	echo * PUBLIC KEY - PUT ME ON GITLAB *
	echo *********************************
	echo
	cat /home/$USERNAME/.ssh/id_rsa.pub
	echo
	chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
	# Start X at connexion
	[ -f ~/.profile ] || touch ~/.profile
	echo "startx" >> /home/$USERNAME/.profile
  SHELL
 
  # Add Development tools
  config.vm.provision "installTools", type: "shell", inline: <<-SHELL
	 sudo apt-get -y -q install curl # >/dev/null 2>&1
	 # NodeJS 
     curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
	 sudo apt-get install -y nodejs # >/dev/null 2>&1
	 # VisualStudio Code
	 curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
	 sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
	 sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
	 sudo apt-get update # >/dev/null 2>&1
	 sudo apt-get install -y libxss1 code # >/dev/null 2>&1
     sudo apt-get install -y git # >/dev/null 2>&1
	 sudo apt-get install -y xfce4 # >/dev/null 2>&1
	 apt-get install chromium chromium-l10n # >/dev/null 2>&1
   SHELL

  # TODO add launcher in panel
  # TODO add git configuration
   
  # Declare provider
  config.vm.provider 'virtualbox' do |vb|
	vb.gui = true
	vb.memory = '1024'
    vb.cpus = '2'
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
  end
end
