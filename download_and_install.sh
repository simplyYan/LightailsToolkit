#!/bin/bash
sudo apt update
sudo apt install -y 

# Check that you are running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root or with sudo!"
    exit 1
fi

# Function to check disk space
check_disk_space() {
    local required_space=5000
    local available_space=$(df -m / | awk 'NR==2 {print $4}')
    
    if [ "$available_space" -lt "$required_space" ]; then
        echo "Error: Not enough disk space. You need at least 5GB free."
        exit 1
    fi
}

# Check disk space
check_disk_space

is_installed() {
    dpkg -l | grep -qw "$1"
}

# List of packages to be checked and installed
packages=(
    git g++ make libssl-dev libpcap-dev libssh2-1-dev
)

# Check and install each package
for package in "${packages[@]}"; do
    if ! is_installed "$package"; then
        echo "Installing $package..."
        sudo apt install -y "$package"
    else
        echo "$package is already installed."
    fi
done

git clone https://github.com/aircrack-ng/mdk4.git mdk4
git clone https://github.com/aircrack-ng/aircrack-ng.git aircrack-ng
git clone https://github.com/nmap/nmap.git nmap
git clone https://github.com/sullo/nikto.git nikto
git clone https://github.com/vanhauser-thc/thc-hydra.git thc-hydra
git clone https://github.com/openwall/john.git john
git clone https://github.com/v0re/dirb.git dirb
git clone https://github.com/trustedsec/social-engineer-toolkit.git social-engineer-toolkit
git clone https://github.com/derv82/wifite2.git wifite2
git clone https://github.com/exiftool/exiftool.git exiftool
git clone https://github.com/hyc/fcrackzip.git fcrackzip
git clone https://github.com/netdiscover-scanner/netdiscover.git netdiscover
git clone https://github.com/mitmproxy/mitmproxy.git mitmproxy
git clone https://github.com/s0md3v/XSStrike.git XSStrike
git clone https://github.com/digininja/CeWL.git CeWL
git clone https://github.com/maurosoria/dirhunt.git dirhunt
git clone https://github.com/projectdiscovery/subfinder.git subfinder
git clone https://github.com/soxoj/maigret.git maigret
git clone https://github.com/lanmaster53/recon-ng.git recon-ng


# Function to check if a command was executed successfully
check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: Command failed: $1"
        exit 1
    fi
}



# Updating repositories
echo "Updating repositories..."
sudo apt update
check_command "apt update"

is_installed() {
    dpkg -l | grep -qw "$1"
}

# Lista de pacotes a serem verificados e instalados
packages=(
    git g++ make libssl-dev libpcap-dev libssh2-1-dev
    build-essential zlib1g-dev yasm pkg-config libgmp-dev libbz2-dev
    libnl-3-dev libnl-genl-3-dev autoconf automake libtool ethtool shtool rfkill
    libsqlite3-dev libpcre2-dev libhwloc-dev libcmocka-dev hostapd wpasupplicant
    tcpdump screen iw usbutils expect libssh-dev libidn11-dev libpcre3-dev
    libgtk2.0-dev python3 python3-pip ruby ruby-dev golang
)

# Verificar e instalar cada pacote
for package in "${packages[@]}"; do
    if ! is_installed "$package"; then
        echo "Instalando $package..."
        sudo apt install -y "$package"
        check_command "apt install $package"
    else
        echo "$package is already installed."
    fi
done

# Tool installation function
install_tool() {
    local tool_name=$1
    local tool_dir=$2
    local install_cmd=$3
    
    echo "Installing $tool_name..."
    if [ ! -d "$tool_dir" ]; then
        echo "Error: Directory $tool_dir not found in $tool_dir"
        exit 1
    fi
    
    cd "$tool_dir" || { echo "Error: Could not access $tool_dir"; exit 1; }
    eval "$install_cmd"
    check_command "Installation of $tool_name"
}

# install tools
sudo pip3 install maigret
sudo apt install -y dmitry macchanger eyewitness theharvester maltego
install_tool "mdk4" "mdk4" "make && sudo make install"
install_tool "aircrack-ng" "aircrack-ng" "autoreconf -i && ./configure --with-experimental && make -j$(nproc) && sudo make install && sudo ldconfig"
install_tool "nmap" "nmap" "./configure && make -j$(nproc) && sudo make install"
install_tool "hydra" "thc-hydra" "./configure && make -j$(nproc) && sudo make install"
install_tool "john" "john/src" "./configure && make -s clean && make -sj$(nproc)"
install_tool "dirb" "dirb/src" "make"
install_tool "set" "social-engineer-toolkit" "pip3 install -r requirements.txt"
install_tool "wifite2" "wifite2" "sudo python3 setup.py install"
install_tool "fcrackzip" "fcrackzip" "make && sudo cp fcrackzip /usr/local/bin/"
install_tool "netdiscover" "netdiscover" "make && sudo cp netdiscover /usr/local/bin/"
install_tool "mitmproxy" "mitmproxy" "pip3 install ."
install_tool "xsstrike" "XSStrike" "pip3 install -r requirements.txt"
install_tool "cewl" "CeWL" "sudo gem install bundler && bundle install"
install_tool "dirhunt" "dirhunt" "pip3 install -r requirements.txt"
install_tool "subfinder" "subfinder" "go get -v ./... && go build -o subfinder . && sudo cp subfinder /usr/local/bin/"
install_tool "recon-ng" "recon-ng" "pip install -r REQUIREMENTS"

# install exiftool
echo "Installing exiftool..."
if [ ! -f "$PENDRIVE_DIR/exiftool/exiftool.pl" ]; then
    echo "Error: File exiftool.pl not found"
    exit 1
fi
sudo cp "$PENDRIVE_DIR/exiftool/exiftool.pl" /usr/local/bin/exiftool
sudo chmod +x /usr/local/bin/exiftool
check_command "Installing exiftool"

echo "Installation successfully completed!"
