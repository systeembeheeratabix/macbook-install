#!/bin/bash

if [ "$EUID" eq 0 ]
  then echo "Please do not run as root"
  exit
fi

echo "Welcome to the Battle Station Setup script."
export OS_VERSION=$(sw_vers | grep ProductVersion | awk '{print $2}' | cut -d. -f1,2)
if  [ "$OS_VERSION" = "10.14" ]; then
  echo "Please install MacOS Mojave first. Terminating."
  exit;
fi

echo "Please enter the email address for the user of this laptop."
read USER_EMAIL
export USER_GROUP=$(groups | awk '{print $1}')

xcode-select --install

# Sudo will be required once during the Homebrew setup.
yes '' | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo 'export PATH="/usr/local/sbin:$PATH"' >> ~/.bash_profile
brew update

brew --version

# Own all of the files created by homebrew.
sudo chown -R $(whoami):$USER_GROUP $(brew --prefix)/*

# Kill the built in Mac OS Apache
sudo apachectl stop
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null

# Install some basic software that is required.
brew install httpd openldap libiconv wget node gnu-sed

# Autostart Brew's Apache
sudo brew services start httpd

# Create development folders for Apache
mkdir -p ~/Development/http/app
mkdir -p ~/Development/http/dev
mkdir -p ~/Development/http/logs

# Download the Apache configuration
export APACHE_PATH=/usr/local/etc/httpd
mkdir -p $APACHE_PATH/vhosts

curl https://raw.githubusercontent.com/brysem/httpd-config-template/master/httpd.conf > $APACHE_PATH/httpd.conf
sed -i -e "s|_USERNAME_|$USER|g" $APACHE_PATH/httpd.conf
sed -i -e "s|_USEREMAIL_|$USER_EMAIL|g" $APACHE_PATH/httpd.conf
sed -i -e "s|_USERGROUP_|$USER_GROUP|g" $APACHE_PATH/httpd.conf

curl https://raw.githubusercontent.com/brysem/httpd-config-template/master/extra/httpd-vhosts.conf > $APACHE_PATH/extra/httpd-vhosts.conf

curl https://raw.githubusercontent.com/brysem/httpd-config-template/master/vhosts/app.conf > $APACHE_PATH/vhosts/app.conf
sed -i -e "s|_USERNAME_|$USER|g" $APACHE_PATH/vhosts/app.conf

curl https://raw.githubusercontent.com/brysem/httpd-config-template/master/vhosts/dev.conf > $APACHE_PATH/vhosts/dev.conf
sed -i -e "s|_USERNAME_|$USER|g" $APACHE_PATH/vhosts/dev.conf

# Install tap for deprecated PHP versions.
brew tap exolnet/homebrew-deprecated

brew install php@5.6
brew install php@7.0
brew install php@7.1
brew install php@7.2
brew install php@7.3

brew link php@5.6 --force
source ~/.bash_profile

mkdir -p $APACHE_PATH/certificates
curl https://raw.githubusercontent.com/brysem/httpd-config-template/master/certificates/*.app.test.crt > $APACHE_PATH/certificates/*.app.test.crt
curl https://raw.githubusercontent.com/brysem/httpd-config-template/master/certificates/*.app.test.csr > $APACHE_PATH/certificates/*.app.test.csr
curl https://raw.githubusercontent.com/brysem/httpd-config-template/master/certificates/*.app.test.key > $APACHE_PATH/certificates/*.app.test.key
curl https://raw.githubusercontent.com/brysem/httpd-config-template/master/certificates/*.dev.test.crt > $APACHE_PATH/certificates/*.dev.test.crt
curl https://raw.githubusercontent.com/brysem/httpd-config-template/master/certificates/*.dev.test.csr > $APACHE_PATH/certificates/*.dev.test.csr
curl https://raw.githubusercontent.com/brysem/httpd-config-template/master/certificates/*.dev.test.key > $APACHE_PATH/certificates/*.dev.test.key

curl https://raw.githubusercontent.com/brysem/httpd-config-template/master/server.crt > $APACHE_PATH/server.crt
curl https://raw.githubusercontent.com/brysem/httpd-config-template/master/server.key > $APACHE_PATH/server.key

# Own all of the files created by homebrew.
sudo chown -R $(whoami):$USER_GROUP $(brew --prefix)/*

sudo brew services restart httpd

curl -L https://gist.githubusercontent.com/rhukster/f4c04f1bf59e0b74e335ee5d186a98e2/raw > /usr/local/bin/sphp
chmod +x /usr/local/bin/sphp

# Install PHP Addons
brew install php-cs-fixer
brew install phpmd
brew install composer

# Install Global PHP Packages
composer global require phpunit/phpunit

# Install MySQL (Account: root:secret)
brew install mysql@5.7
brew services start mysql@5.7
brew link mysql@5.7
mysqladmin -u root password 'secret'

# Install Software
brew tap caskroom/fonts
brew cask install iterm2
brew cask install visual-studio-code
brew cask install tower
brew cask install google-chrome
brew cask install slack
brew cask install sequel-pro
brew cask install spotify
brew cask install postman

brew cask install font-fira-code
brew cask install font-fira-mono
brew cask install font-fira-mono-for-powerline
brew cask install font-fira-sans

# Install Visual Studio Code Packages.
#

# Setup DNSmasq
brew install dnsmasq
echo -e "address=/.test/127.0.0.1" > /usr/local/etc/dnsmasq.conf
sudo brew services restart dnsmasq
sudo mkdir -v /etc/resolver
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/test'

# Set up SSH Key
ssh-keygen -t rsa -N "" -b 4096 -C $USER_EMAIL -f ~/.ssh/id_rsa

# Install Node Version Manager
npm install -g n
sudo mkdir -vp /usr/local/n
sudo chown $(whoami):$USER_GROUP $(brew --prefix)/n

# Install required versions
n 0.10.48
n latest