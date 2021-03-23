# Build and Install Grub2-v2.04 on Ubuntu 16.04.7 x86

## 1. Pre-requisites
```

sudo apt install bison flex autoconf libdevmapper-dev
sudo apt install grub-efi-ia32-bin grub-efi-amd64-bin grub-pc-bin grub2-common grub-efi-ia32
sudo apt install bison libopts25 libselinux1-dev autogen m4 autoconf help2man libopts25-dev flex libfont-freetype-perl automake autotools-dev libfreetype6-dev texinfo
sudo apt install autopoint
```

## 1. Checkout source code:
```
git clone https://git.savannah.gnu.org/git/grub.git
git checkout grub-2.04
```

## 2. Build grub. In grub/ folder:
The commands for non-UEFI boot loader of x86 platforms

```
./bootstrap
./configure --target=i386 --with-platform=pc
make -j4
```

## 3. Install grub. In grub/ folder:
Replace /dev/sdX with correct hard disks (e.g., /dev/sda) 

```
sudo ./grub-install /dev/sdX
```


## References:
(1) https://stackoverflow.com/questions/31799336/how-to-build-grub2-bootloader-from-its-source-and-test-it-with-qemu-emulator

(2) https://www.rmprepusb.com/useful-articles/grub2
