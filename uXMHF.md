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

## 4. Setup grub
Refer to https://docs.uberxmhf.org/pc-intel-x86_32/installing.html



# Related Documents
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
1. https://medium.com/swlh/how-to-use-docker-images-containers-and-dockerfiles-39e4e8fc181a
