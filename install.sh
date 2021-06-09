#!/bin/bash

if [ "$EUID" -eq 0 ]
  then echo "Please do not run as root"
  exit
fi

echo "Welcome to the Battle Station Setup script."
export OS_VERSION=$(sw_vers -productVersion | cut -d. -f1,2)
echo "MacOS version $OS_VERSION detected."

if  [ ${OS_VERSION} != 10.15 ]; then
  echo "This script requires MacOS Catalina ($OS_VERSION). Please install it first by updating the OS. Terminating."
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
echo 'export PATH="/usr/local/sbin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

brew update
brew --version

# Own all of the files created by homebrew.
sudo chown -R $(whoami):$USER_GROUP $(brew --prefix)/*

# Kill the built in Mac OS Apache
sudo apachectl stop
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null

# Install some basic software that is required.
brew install httpd openldap libiconv wget node gnu-sed svn

# Autostart Brew's Apache
sudo brew services start httpd

# Create development folders for Apache
mkdir -p ~/Development/http/app
mkdir -p ~/Development/http/dev
mkdir -p ~/Development/http/logs
touch ~/Development/.metadata_never_index

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

brew install php@7.3
brew install php@7.4
brew install php@8.0

brew link php@7.3 --force --overwrite
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

curl -L https://gist.githubusercontent.com/rhukster/f4c04f1bf59e0b74e335ee5d186a98e2/raw > /usr/local/bin/sphp
chmod +x /usr/local/bin/sphp

# Install PHP Addons
brew install composer

# PHP CS Fixer
mkdir -p /usr/local/lib/php-cs-fixer
composer require --working-dir=/usr/local/lib/php-cs-fixer friendsofphp/php-cs-fixer
ln -s /usr/local/lib/php-cs-fixer/vendor/bin/php-cs-fixer /usr/local/bin/php-cs-fixer

# Install Global PHP Packages
composer global require phpunit/phpunit

# Install MySQL (Account: root:secret)
brew install mysql@5.7
brew services start mysql@5.7
brew link mysql@5.7 --force
mysqladmin -u root password 'secret'

# Add-ons
brew install redis
brew install zsh
brew install awscli
brew install aws-elasticbeanstalk

# Install Software
brew tap homebrew/cask-fonts
brew install iterm2
brew install visual-studio-code
brew install tower
brew install google-chrome
brew install slack
brew install sequel-pro
brew install spotify
brew install postman
brew install authy
# brew install microsoft-office
brew install libreoffice

brew install font-fira-code
brew install font-fira-mono
brew install font-fira-mono-for-powerline
brew install font-fira-sans

# Install Visual Studio Code Packages.
ln -s /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code /usr/local/bin/code

# Check these step for step. Where some broken.
code --install-extension alefragnani.project-manager
code --install-extension bmewburn.vscode-intelephense-client
code --install-extension calebporzio.better-phpunit
code --install-extension codingyu.laravel-goto-view
code --install-extension CoenraadS.disableligatures
code --install-extension cymonk.sql-formatter
code --install-extension dkundel.vscode-new-file
code --install-extension DotJoshJohnson.xml
code --install-extension EditorConfig.EditorConfig
code --install-extension esbenp.prettier-vscode
code --install-extension felixfbecker.php-debug
code --install-extension fetzi.php-file-types
code --install-extension imperez.smarty
code --install-extension junstyle.php-cs-fixer
code --install-extension linyang95.phpmd
code --install-extension MehediDracula.php-constructor
code --install-extension MehediDracula.php-namespace-resolver
code --install-extension mikestead.dotenv
code --install-extension moppitz.vscode-extension-auto-import
code --install-extension mrmlnc.vscode-apache
code --install-extension mrmlnc.vscode-duplicate
code --install-extension neilbrayfield.php-docblocker
code --install-extension octref.vetur
code --install-extension onecentlin.laravel-blade
code --install-extension phiter.phpstorm-snippets
code --install-extension sachittandukar.laravel-5-snippets
code --install-extension steoates.autoimport
code --install-extension Tyriar.lorem-ipsum
code --install-extension vscode-icons-team.vscode-icons
code --install-extension waderyan.gitblame
code --install-extension wesbos.theme-cobalt2
code --install-extension yzhang.markdown-all-in-one
code --install-extension sleistner.vscode-fileutils
code --install-extension ziyasal.vscode-open-in-github
code --install-extension DavidAnson.vscode-markdownlint
code --install-extension cjhowe7.laravel-blade
code --install-extension felixfbecker.php-pack

# Setup DNSmasq
brew install dnsmasq
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
n 0.10.48
n latest

# Setup ZSH
sudo sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)

# Install Nativescript
sudo gem install xcodeproj
sudo gem install cocoapods

pod setup
sudo easy_install pip
pip install six

brew install --cask adoptopenjdk
brew install --cask android-studio

echo 'export ANDROID_HOME=$HOME/Library/Android/sdk' >> ~/.bash_profile
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bash_profile
source ~/.bash_profile

npm install -g nativescript
tns doctor
