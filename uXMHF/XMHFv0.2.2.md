Most steps are same with [uXMHF.md](uXMHF.md)


# Setup grub entry
## 1. Setup grub2 for legacy XMHF (XMHF v0.2.2)
In grub2 (version 1.9.9), one can use the tool grub-customizer and add one grub entry XMHF as follows:
```
set root='(hd0,msdos5)'
set kernel='/boot/init-x86.bin'
echo "Loading ${kernel}..."
multiboot	${kernel} serial=115200,8n1,0x5080
module /boot/hypervisor-x86.bin.gz
module --nounzip (hd0)+1 # should point to where grub is installed
module /boot/i5_i7_DUAL_SINIT_51.BIN
```