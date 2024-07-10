# Mac Installation Script
1. First install xcode in a terminal
```
xcode-select --install
```
3. Then, if it's an arm64 based laptop (M1, M2, etc), run
```
sudo softwareupdate --install-rosetta
```
5. Lastly we run the install script:
```
curl https://raw.githubusercontent.com/atabix/macbook-install/main/install.sh | zsh
```