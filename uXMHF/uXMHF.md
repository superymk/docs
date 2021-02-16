# Build uberXMHF v6.0.0
## 1. Create ubuntu virtual machine on your development machine (NOT the testbed), and install Docker
(1) Install [Ubuntu 20.04.2 x64](https://releases.ubuntu.com/20.04/ubuntu-20.04.2-desktop-amd64.iso) in a virtual machine (I used VMWare Player 16).

(2) Run the following commands to install Docker

```
# Update the apt package list.
sudo apt-get update -y

# Install Docker's package dependencies.
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Download and add Docker's official public PGP key.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Verify the fingerprint.
sudo apt-key fingerprint 0EBFCD88

# Add the `stable` channel's Docker upstream repository.
# You can change `stable` below to `test` or `nightly` if you prefer living on the edge!
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"

# Update the apt package list (for the new apt repo).
sudo apt-get update -y

# Install the latest version of Docker CE.
sudo apt-get install -y docker-ce

# Allow your user to access the Docker CLI without needing root access.
sudo usermod -aG docker $USER
```

(3) Reboot so that you can run Docker without sudo.

## 2. Build Docker image of uberSpark v6.0.0
(1) Download the [Docker File](uXMHF/Dockerfile) under the home folder ~/.

(2) Build the Docker image

```
docker build -t "dev:uberspark_v6" .
```
(It could takes ~40 minutes)


## 3. Build uberXMHF v6.0.0
(1) Download uberXMHF v6.0.0 and decompress it to the home folder ~/.

(2) Start the docker container and share the uberXMHF folder to the container
```
docker run -dit --name dev -v ~/uberxmhf-6.0.0:/home/opam/opam-repository/run/uberxmhf-6.0.0 dev:uberspark_v6
```

(3) Build uberXMHF in the container

Replace 0x5080 with the system serial port number on the testbed that will run uxmhf (e.g., 0x3f8 for COM1), and replace 4 with the number of cores on the testbed.

```
cd ~/opam-repository/run/uberxmhf-6.0.0/uxmhf
./bsconfigure.sh
./configure --enable-debug-serial=0x5080 --with-debug-serial-maxcpus=4
make uxmhf-image
```

(4) Outside the container, copy ~/uberxmhf-6.0.0/uxmhf/_objects/xmhf-x86-vmx-x86pc.bin.gz to the /boot folder of the target machine



# Setup Testbed (tested with HP EliteBook 2540p)

## 1. Setup Ubuntu on testbed
(1) Enter BIOS, set hard disk mode to be "IDE". Then install Ubuntu 16.04.7 x86 on the testbed

(2) Use a Non-PAE Linux kernel (Linux Kernel 4.4.x and below)
Method 1 (tested): Download pre-built [images](https://github.com/uberspark/uberxmhf-linux-kernels/raw/master/ubuntu/x86_32/v4.4.x/linux-image-4.4.236-uberxmhf_4.4.236-uberxmhf-3_i386.deb) and [headers](https://github.com/uberspark/uberxmhf-linux-kernels/raw/master/ubuntu/x86_32/v4.4.x/linux-headers-4.4.236-uberxmhf_4.4.236-uberxmhf-3_i386.deb), then install them with 
```
sudo dpkg -i linux-image-4.4.236-uberxmhf_4.4.236-uberxmhf-3_i386.deb
sudo dpkg -i linux-headers-4.4.236-uberxmhf_4.4.236-uberxmhf-3_i386.deb
```

Method 2: Build a Non-PAE Linux kernel
Clear the CONFIG_X86_PAE in the .config file, see the [website](https://docs.uberxmhf.org/pc-intel-x86_32/supported-os.html)

(3) Downgrade to grub-legacy
Method 1 (tested): Use boot-repair in Ubuntu and install grub legacy

Method 2: See the [website](https://docs.uberxmhf.org/pc-intel-x86_32/installing.html#downgrade-from-grub-2-to-grub-1)

(4) Blacklist modules and change kernel boot parameters
> Modify /etc/modprobe.d/blacklist.conf, and blacklist `kvm`, `kvm_intel`, and `intel_rapl`
> Modify /boot/grub/menu.lst, add `nmi_watchdog=0` to boot command options; i.e., modify `kernel		/boot/vmlinuz-4.4.236-uberxmhf root=UUID=347d80d8-e115-4c44-b37a-b14bf4b5f8fd ro quiet splash` to be `kernel		/boot/vmlinuz-4.4.236-uberxmhf root=UUID=347d80d8-e115-4c44-b37a-b14bf4b5f8fd ro quiet splash nmi_watchdog=0`

(5) Get the correct SINIT module
See the [website](https://docs.uberxmhf.org/pc-intel-x86_32/installing.html#get-the-correct-sinit-module)

(6) Install uXMHF
Copy xmhf-x86-vmx-x86pc.bin.gz and SINIT module (e.g., i5_i7_DUAL_SINIT_51.BIN) to the /boot folder of the target machine


## 2. Setup grub entry
### For grub v0.97
Refer to https://docs.uberxmhf.org/pc-intel-x86_32/installing.html

Example:
```
title uberXMHF
rootnoverify (hd0,4) # should point to /boot
kernel /boot/xmhf-x86-vmx-x86pc.bin.gz serial=115200,8n1,0x5080
modulenounzip (hd0)+1 # should point to where grub is installed
modulenounzip /boot/i5_i7_DUAL_SINIT_51.BIN  # SINIT for HP EliteBook 2540p
```

Additionally, one may want to change `default`, `timeout`, and `hiddenmenu` setting in grub's `menu.lst` file to improve debugging experience. Example:
```
## default num
# Set the default entry to the entry number NUM. Numbering starts from 0, and
# the entry number 0 is the default if the command is not used.
#
# You can specify 'saved' instead of a number. In this case, the default entry
# is the entry saved with the command 'savedefault'.
# WARNING: If you are using dmraid do not use 'savedefault' or your
# array will desync and will not let you boot your system.
default		1

## timeout sec
# Set a timeout, in SEC seconds, before automatically booting the default entry
# (normally the first entry defined).
timeout		10

## hiddenmenu
# Hides the menu by default (press ESC to see the menu)
#hiddenmenu
```

### For grub v1.9.9
one can use the tool grub-customizer to modify grub, and add one entry XMHF as follows:
```
set root='(hd0,5)'
set kernel='/boot/xmhf-x86-vmx-x86pc.bin.gz'
echo "Loading ${kernel}..."
multiboot	${kernel} serial=115200,8n1,0x5080
module --nounzip (hd0)+1 # should point to where grub is installed
module --nounzip /boot/i5_i7_DUAL_SINIT_51.BIN
```



# Related Materials
## Docker commands
(1) Run docker container: 
```
docker run -dit --name dev dev:uberspark_v6
```

(2) Stop and Remove docker container:
```
docker stop dev && docker rm dev
```

(3) Attach to the "dev" container:
```
docker attach dev
```

(4) List docker containers:
```
docker ps -a
```

## Related documents
1. https://medium.com/swlh/how-to-use-docker-images-containers-and-dockerfiles-39e4e8fc181a
