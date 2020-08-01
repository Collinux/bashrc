# Setup for Kali Linux running i3 Window Manager
# Copy this file to /home/$USER/.bashrc
# Note: All install commands assume the aptitute (apt-get) package manager is used

# Browser
# Start internal and external firefox instances, where the internal
# browser is for trusted sites and the external browser is for 
# untrusted sites / general browsing.
alias fi='nohup ~/.firefox/firefox -no-remote -P internal > /dev/null 2>&1' # Start browser without blockers
alias fe='nohup ~/.firefox/firefox -no-remote -P external > /dev/null 2>&1' # Start browser with all blockers
alias ff='fi & fe &'

# System
export PS1="\n\u@\h:\W> \[$(tput sgr0)\]"
export GOPATH=~/proj/go
alias vi='vim'
alias cls='bleachbit --clean --preset && history -c && clear && sudo bash -c "bleachbit --clean --preset" && history -c && clear'
alias llight='sudo bash -c "echo '1500' > /sys/class/backlight/intel_backlight/brightness"'
alias mlight='sudo bash -c "echo '4500' > /sys/class/backlight/intel_backlight/brightness"'
alias hlight='sudo bash -c "echo '7500' > /sys/class/backlight/intel_backlight/brightness"'

# Terminal
alias ls='ls --color=always'
alias ll='ls -lah --color=always'
alias cd..='cd ../'
alias ..='cd ../'
alias ...='cd ../../'
alias .2='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'
alias .6='cd ../../../../../../'

# Kubernetes
export KUBECONFIG=~/.kube/configs/dev/config
alias kcx="kubectl config set-context --current --namespace"
alias kgp="kubectl get pods"
alias wkgp="watch kubectl get pods --sort-by='.status.containerStatuses[0].restartCount'"
alias ka='kubectl apply -f'
alias kc='kubectl create -f'
alias kr='kubectl replace -f'
alias kd='kubectl delete -f'
alias kl='kubectl logs'
alias kt='kubectl top'
alias ke='kubectl exec -it'
# BE CAREFUL WITH THIS! - Clears everything in my namespace
alias kcl='kubectl delete deploy,cm,po,svc,rc,rs,sts --all --namespace $USER'
# Get pods and sort by number of restarts ascending
alias kgpn='kubectl get pod -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName'

# Docker
# BE CAREFUL WITH THIS! - Clears all docker images on the system
alias dcl='docker rmi $(docker images -qa) --force; docker system prune --all --force'
alias dst='docker stats --format "{{.Container}}: {{.CPUPerc}}"'
alias dps='docker ps'

# Git
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gbd='git branch -d '
alias gc='git commit -m'
alias gcl='git clone'
alias gco='git checkout'
alias gcom='git checkout master'
alias gcob='git checkout -b'
alias gd='git diff'
alias gdh='git diff HEAD'
alias gi='git init'
alias gl='git log'
alias gp='git pull'
alias gps='git push'
alias gs='git status'
alias gst='git stash'

#-------------------------------------------------------------------------------
#                             SETUP COMMANDS
#-------------------------------------------------------------------------------
# Note: Grab ssh keys, kube configs, and vpn configs from a secure location.

# Use nmcli, nmtui, or nm-applet (NetworkManager-applet)
#nmcli connection import type openvpn file ~/Downloads/<file>
# Edit all files in /etc/NetworkManager/system-connection after importing
# Change "password-flags" to 0 for the password to be saved
#sudo vim /etc/NetworkManager/system-connections/<connection-name> 
#nmcli connection modify <connection-name> +vpn.data username=<username>
#nmcli connection modify mypreviousname con-name mynewname
#nmcli --ask con up <connection-name>

alias setupall="setupterminal && setupcontainers && setupi3"


# ------------------- SETUP TERMINAL ----------------------
# See setupterminal parent alias

alias setuprepo="echo -e 'deb http://http.kali.org/kali kali-rolling main non-free contrib\n' >> /etc/apt/sources.list"

alias setuppackages="sudo apt-get install -y \
vim i3 i3status git feh xclip keepassxc bleachbit \
golang xdotool tree htop rxvt-unicode redshift"

alias setupbashprofile="echo -e '\
eval \$(ssh-agent) > /dev/null 2>&1 \n\
ssh-add ~/.ssh/my-ssh-key > /dev/null 2>&1'\
> ~/.bash_profile"

alias setupvimrc="echo -e \
'execute pathogen#infect() \n\
set nowrap number rnu tabstop=4 shiftwidth=4 lazyredraw \n\
syntax on \n\
highlight OverLength ctermbg=red ctermfg=white guibg=#592929 \n\
match OverLength /\%81v.\+/ \n\
au BufWritePost *.go !gofmt -w % \
imap jj <Esc> \
' > ~/.vimrc" 

alias setupvimpkg="\
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim && \
git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go && \
git clone https://github.com/tpope/vim-surround.git ~/.vim/bundle/vim-surround"

alias setupgit="git config --global user.name myname && git config --global user.email myname@users.noreply.github.com"

alias setupterminal="setuprepo && setuppackages && setupbashprofile && setupvimrc && setupvimpkg && setupgit"


# ------------------- SETUP CONTAINERS ----------------------
# See setupcontainers parent alIAs
# To manage multiple clusters create them under
# ~/.kube/configs/
# ├── dev
# │   └── config
# └── qa
#     └── config
alias setupdocker="sudo groupadd docker; sudo usermod -aG docker $USER; newgrp docker; sudo systemctl start docker"

alias setupkubectl="kubectl create -f myingress.ing && \
mv myconfig ~/.kube/config && \
kubectl config set-context --current --namespace=$USER"

alias setupcontainers="setupdocker && setupkubectl"


# ------------------- SETUP WINDOW MANAGER ----------------------
alias setupi3xinit='echo -e "exec i3; startx; urxvt; xset r rate 200 50" > ~/.xinitrc'

#####################    Paste this into /etc/i3/config using Shift+Insert on urxvt
## Universal functions
#bindsym Mod1+Ctrl+L exec i3lock -c 000000
#bindsym Mod1+Ctrl+Delete exec clear ; bleachbit --clean --preset ; clear ; shutdown now
#exec --no-startup-id xsetroot -solid "#000000" # Black desktop background
#
#bindsym Mod1+o mode "nav"
#mode "nav" {
#
#	# Re-add universal functions
#	bindsym Mod1+Ctrl+L exec i3lock -c 000000
#	bindsym Mod1+Ctrl+Delete exec clear ; bleachbit --clean --preset ; clear && shutdown now
#	bindsym Mod1+o mode "default"
#
#	# Use the right side of the keyboard to navigate
#	bindsym --release j exec --no-startup-id xdotool key --clearmodifiers Down
#	bindsym --release k exec --no-startup-id xdotool key --clearmodifiers Up
#	bindsym --release h exec --no-startup-id xdotool key --clearmodifiers Left
#	bindsym --release l exec --no-startup-id xdotool key --clearmodifiers Right
#	bindsym --release u exec --no-startup-id xdotool key --clearmodifiers Next
#	bindsym --release i exec --no-startup-id xdotool key --clearmodifiers Prior
#
#	# Left Click-and-drag
#	#bindsym Shift+f exec xdotool mousedown 1
#
#	# Middle Click-and-drag
#	#bindsym Shift+d exec xdotool mousedown 2
#
#	# Left Drag release
#	#bindsym Mod2+f exec xdotool mouseup 1
#
#	# Middle Drag release
#	#bindsym Mod2+d exec xdotool mouseup 2
#
#	# Right Drag release
#	#bindsym Mod2+s exec xdotool mouseup 3
#
#	# Left Click
#	bindsym a exec xdotool click 1
#
#	# Right Click
#	bindsym Shift+A exec xdotool click 3
#
#	# Sensitivity of movement. Also depends on repeat speed.
#	set $slow 20
#	set $fast 100
#	# Use the left side of the keyboard to move the mouse
#	# Fast
#	bindsym s exec xdotool mousemove_relative -- -$fast 0
#	bindsym f exec xdotool mousemove_relative 0 $fast
#	bindsym d exec xdotool mousemove_relative -- 0 -$fast
#	bindsym g exec xdotool mousemove_relative $fast 0
#	# Slow
#	bindsym Shift+S exec xdotool mousemove_relative -- -$slow 0
#	bindsym Shift+F exec xdotool mousemove_relative 0 $slow
#	bindsym Shift+D exec xdotool mousemove_relative -- 0 -$slow
#	bindsym Shift+G exec xdotool mousemove_relative $slow 0
#}
#EOF'"

#####################    Replace line "bindsym Mod1+return exec i3-sensible-terminal" with "bindsym Mod1+return exec urxvt"

#####################    Paste this into /etc/i3status.conf using Shift+Insert on urxvt
#volume master {
#	format = "♪ %volume"
#	format_muted = "♪ muted %volume"
#	device = "default"
#	mixer = "Master"
#}
#wireless wlan0 {
#	format_up = "W: (%quality at %essid) %ip"
#	format_down = "W: down"
#}
#path_exists VPN {
#	# path exists when a VPN tunnel launched by nmcli/nm-applet is active
#	path = "/proc/sys/net/ipv4/conf/tun0"
#}
#general { colors = true interval = 60 }
#tztime local { format = "%m-%d %I:%M"}
#load { format = "%1min" }
#
#battery 0 {
#        format = "%status %percentage"
#        format_down = "No battery"
#        status_chr = "CHR"
#        status_bat = "BAT"
#        status_unk = "UNK"
#        status_full = "FULL"
#        path = "/sys/class/power_supply/BAT/uevent"
#        low_threshold = 10
#}
#
#order += "battery 0"
#order += "path_exists VPN"
#order += "wireless wlan0"
#order += "load"
#order += "tztime local"
#order += "volume master"

alias setupurxvt="sudo sh -c 'cat > /home/$USER/.Xresources << EOF
URxvt*font: xft:Monospace:pixelsize=16
URxvt*background: #000000
URxvt*foreground: #ffffff
EOF' && xrdb -merge /home/${USER}/.Xresources"

alias setupi3="setupi3xinit && setupurxvt"

# Setup monitors
# 1. Use 'cvt' to calculate the resolution mode (<x> <y> <Hz>)
#  Note: Some machines may only support 30Hz, others 60Hz+
# 	ex: cvt 2560 1440 30 
# 2. Use the cvt output to add a new mode using xrandr
#  xrandr --newmode "2560x1440_30.00"  146.25  2560 2680 2944 3328  1440 1443 1448 1468 -hsync +vsync
# 3. Add the mode to your desired output (use 'xrandr' with no args to display output options)
#  xrandr --addmode HDMI-1 2560x1440_30.00
# 4. Change the mode of the output to the new mode
#  xrandr --output HDMI-1 --mode 2560x1440_30.00

# Setup redshift to change your screen to a peachy color at night
# ~/.config/redshift.conf
# [redshift]
# temp-day=6500
# temp-night=2500
# gamma=0.8
# adjustment-method=vidmode
# location-provider=manual
#
# [manual]
# (get this from a map)
# lat=
# lon=
