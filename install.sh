#!/bin/bash

if [ "$EUID" -eq 0 ]
  then echo "Please do not run as root"
  exit
fi

function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

echo "Welcome to the Battle Station Setup script."
export OS_VERSION=$(sw_vers -productVersion | cut -d. -f1,2)
echo "MacOS version $OS_VERSION detected."

if [ $(version $OS_VERSION) -lt $(version "12.5") ]; then
  echo "This script requires MacOS Monterey ($OS_VERSION). Please install it first by updating the OS. Terminating."
  exit 1
fi

if [ -x "$(command -v brew)" ]; then
  echo 'Error: brew has already been installed. The laptop is not a clean install.' >&2
  exit 1
fi

echo "Please enter the email address for the new user of this laptop."
read USER_EMAIL
export USER_GROUP=$(groups | awk '{print $1}')

# Install Xcode
xcode-select --install
# Also check this issue https://github.com/nodejs/node-gyp/issues/569#issuecomment-94917337
# sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

# Sudo will be required once during the Homebrew setup.
yes '' | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
echo 'export PATH="/usr/local/sbin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

brew update
brew --version

# Own all of the files created by homebrew.
sudo chown -R $(whoami):$USER_GROUP $(brew --prefix)/*

# Install some basic software that is required.
brew install httpd openldap libiconv wget node gnu-sed svn git git-lfs php@7.4 php@8.0 php@8.1 mysql@5.7 composer redis zsh awscli aws-elasticbeanstalk dnsmasq
brew install google-chrome
brew install visual-studio-code
brew install iterm2
brew install sequel-ace
brew install tower
brew install postman
brew install slack
brew install spotify
brew install authy
# brew install microsoft-office
brew install libreoffice

git lfs install

# Autostart Brew's Apache
sudo brew services start httpd

# Create development folders for Apache
mkdir -p ~/Development/http/app
mkdir -p ~/Development/http/dev
mkdir -p ~/Development/http/logs
touch ~/Development/.metadata_never_index

# Download the Apache configuration
export BREW_PATH=$(brew --prefix)
export APACHE_PATH=$BREW_PATH/etc/httpd
echo $APACHE_PATH
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

brew link php@8.0 --force --overwrite
source ~/.bash_profile

mkdir -p $APACHE_PATH/certificates
curl 'https://raw.githubusercontent.com/brysem/httpd-config-template/master/certificates/*.app.test.crt' > "$APACHE_PATH/certificates/*.app.test.crt"
curl 'https://raw.githubusercontent.com/brysem/httpd-config-template/master/certificates/*.app.test.csr' > "$APACHE_PATH/certificates/*.app.test.csr"
curl 'https://raw.githubusercontent.com/brysem/httpd-config-template/master/certificates/*.app.test.key' > "$APACHE_PATH/certificates/*.app.test.key"
curl 'https://raw.githubusercontent.com/brysem/httpd-config-template/master/certificates/*.dev.test.crt' > "$APACHE_PATH/certificates/*.dev.test.crt"
curl 'https://raw.githubusercontent.com/brysem/httpd-config-template/master/certificates/*.dev.test.csr' > "$APACHE_PATH/certificates/*.dev.test.csr"
curl 'https://raw.githubusercontent.com/brysem/httpd-config-template/master/certificates/*.dev.test.key' > "$APACHE_PATH/certificates/*.dev.test.key"

curl https://raw.githubusercontent.com/brysem/httpd-config-template/master/server.crt > $APACHE_PATH/server.crt
curl https://raw.githubusercontent.com/brysem/httpd-config-template/master/server.key > $APACHE_PATH/server.key

# Own all of the files created by homebrew.
sudo chown -R $(whoami):$USER_GROUP $(brew --prefix)/*

# Prevent indexing our logs, databases, etc.
touch /usr/local/var/.metadata_never_index

sudo brew services restart httpd

curl -L https://raw.githubusercontent.com/brysem/macbook-install/master/sphp > /usr/local/bin/sphp
chmod +x /usr/local/bin/sphp

# PHP CS Fixer
mkdir -p /usr/local/lib/php-cs-fixer
composer require --working-dir=/usr/local/lib/php-cs-fixer friendsofphp/php-cs-fixer
ln -s /usr/local/lib/php-cs-fixer/vendor/bin/php-cs-fixer /usr/local/bin/php-cs-fixer
curl 'https://raw.githubusercontent.com/atabix/code-style/main/php-cs-fixer.dist.php' > "~/Development/.php-cs-fixer.dist.php"

# Install Global PHP Packages
composer global require phpunit/phpunit

# Install MySQL (Account: root:secret)
brew services start mysql@5.7
brew link mysql@5.7 --force
mysqladmin -u root password 'secret'

# Check these step for step. Where some broken.
code --install-extension mrmlnc.vscode-apache
code --install-extension atabixsolutions.hephaestus
code --install-extension steoates.autoimport
code --install-extension ldd-vs-code.better-package-json
code --install-extension calebporzio.better-phpunit
code --install-extension jeff-hykin.better-syntax
code --install-extension ikappas.composer
code --install-extension coenraads.disableligatures
code --install-extension mikestead.dotenv
code --install-extension mrmlnc.vscode-duplicate
code --install-extension waderyan.gitblame
code --install-extension amiralizadeh9480.laravel-extra-intellisense
code --install-extension mohamedbenhida.laravel-intellisense
code --install-extension stef-k.laravel-goto-controller
code --install-extension ms-vsliveshare.vsliveshare-pack
code --install-extension jaguadoromero.vscode-php-create-class
code --install-extension junstyle.php-cs-fixer
code --install-extension bmewburn.vscode-intelephense-client
code --install-extension mehedidracula.php-namespace-resolver
code --install-extension xdebug.php-debug
code --install-extension alefragnani.project-manager
code --install-extension vue.volar
code --install-extension vscode-icons-team.vscode-icons
code --install-extension bradlc.vscode-tailwindcss
code --install-extension fireyy.vscode-language-todo

# Setup DNSmasq
echo "address=/.test/127.0.0.1" > /usr/local/etc/dnsmasq.conf
sudo brew services restart dnsmasq
sudo mkdir -v /etc/resolver
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/test'

# Get Bryse's help project
git clone https://github.com/brysem/macbook-install.git ~/Development/http/app/help
$(cd ~/Development/http/app/help; composer install)
open http://help.app.test

# Set up SSH Key
ssh-keygen -m PEM -t rsa -b 4096 -C $USER_EMAIL -f ~/.ssh/id_rsa

# Install Node Version Manager
npm install -g n
sudo mkdir -vp /usr/local/n
sudo chown $(whoami):$USER_GROUP $(brew --prefix)/n

# Install required versions
n 14
n latest

# Setup ZSH
sudo sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
compaudit | xargs chmod g-w,o-w

# Install Nativescript iOS
brew install ruby@2.6
brew link ruby@2.6

echo 'export PATH=/usr/local/lib/ruby/gems/2.6.0/bin:$PATH' >> ~/.bash_profile

sudo gem install cocoapods
sudo gem install xcodeproj

pod setup
sudo easy_install pip==20.3.3
python -m pip install six

# Install Nativescript Android
brew tap adoptopenjdk/openjdk
brew install --cask adoptopenjdk8
brew install --cask android-studio

echo 'export ANDROID_HOME=$HOME/Library/Android/sdk' >> ~/.zshrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.zshrc
source ~/.zshrc


echo "Open Android Studio and run the initial setup."

npm install -g nativescript
ns doctor android

# Setup Architect
mkdir -p /usr/local/lib/atabix/architect
echo '{"repositories": [{ "type": "composer", "url": "https://KBGjLxKV1ghg3vethQZTB:NtpfhZzvjD3nAJvZjXeEqye@satis.atabix.com" }]}' > /usr/local/lib/atabix/architect/composer.json
composer require --working-dir=/usr/local/lib/atabix/architect atabix/architect
ln -s /usr/local/lib/atabix/architect/vendor/bin/architect /usr/local/bin/architect
