#!/bin/sh

# START PART 1
# Homebrew Script for OSX
# To execute: save and `chmod +x ./brew-install-script.sh` then `./brew-install-script.sh`
xcode-select --install
# END PART 1

# PART 2
sudo chown -R $(whoami) $(brew --prefix)/share/zsh $(brew --prefix)/share/zsh/site-functions
chmod u+w $(brew --prefix)/share/zsh $(brew --prefix)/share/zsh/site-functions
echo "Installing brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
logs
touch $(brew --prefix)/.metadata_never_index

# Wait for brew to be installed and add the brew command to be recognized in the shell
echo 'eval "$($(brew --prefix)/bin/brew shellenv)"' >> ~/.zprofile
eval "$($(brew --prefix)/bin/brew shellenv)"
# END PART 2

###################################### NOTE #########################################
# START PART 3 Note: Only start with this part when part 1 and 2 are completed!

# Update Brew
echo "Updating Brew, please wait..."
brew update

# Virtualization & Containerizing Tools
echo "Installing virtualization & containerizing tools"
brew install --cask docker

# Dev Tools
echo "Installing development tools"
brew install --cask herd
brew install --cask tower
curl https://get.volta.sh | bash
~/.volta/bin/volta install node
brew install --cask phpstorm
brew install --cask npm
brew install --cask node

# Create Dev folders & Never index
mkdir -p ~/Development/http/app
mkdir -p ~/Development/http/dev
mkdir -p ~/Development/http/logs
touch ~/Development/.metadata_never_index

# PHP CS Fixer
mkdir -p $(brew --prefix)/lib/php-cs-fixer
composer require --dev --working-dir=$(brew --prefix)/lib/php-cs-fixer friendsofphp/php-cs-fixer
ln -s $(brew --prefix)/lib/php-cs-fixer/vendor/bin/php-cs-fixer $(brew --prefix)/bin/php-cs-fixer
curl https://raw.githubusercontent.com/atabix/macbook-install/main/assets/scripts/php-cs-fixer.dist.php > ~/Development/.php-cs-fixer.dist.php

# Git Tools
echo "Installing Git tools"
brew install git git-lfs git-svn
git lfs install

# Database tools

echo "Installing database tools"
brew install --cask tableplus
brew install --cask dbngin

# Editors / Command line tools
brew install --cask visual-studio-code
brew install gnu-sed
brew install zsh
brew install --cask iterm2 

# AWS Tools
echo "Installing AWS tools"
brew install aws-elasticbeanstalk
brew install awscli 

# Web Tools
echo "Installing web tools"
brew install --cask google-chrome
brew install --cask postman

# Programming languages
brew install cocoapods

echo "Installing Mobile tools"
if [[ $(uname -m) == 'arm64' ]]; then
    sudo softwareupdate --install-rosetta
fi
brew install --cask flutter
brew install --cask android-studio
brew install java

echo 'export PATH="$(brew --prefix)/opt/openjdk/bin:$PATH"' >> ~/.zshrc

# Other apps
brew install --cask spotify
brew install --cask authy
brew install --cask teamviewer
brew install --cask raycast
brew install --cask rectangle
brew install --cask firefox
brew install --cask adobe-acrobat-reader
#optional brew install --cask adobe-creative-cloud

# Auto upgrade brew
mkdir -p /Users/$(whoami)/Library/LaunchAgents
brew autoupdate start 86400 --upgrade --cleanup --enable-notification

# Check these step for step. Where some broken. INSTALL THIS PART AFTER VISUAL STUDIO CODE HAS BEEN INSTALLED!

# If `code` alias is missing you can add it to the path: https://code.visualstudio.com/docs/setup/mac
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
