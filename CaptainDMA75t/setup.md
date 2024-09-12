# Use Captain DMA 75t FPGA board to test DMA protection
## 1. Connect the debuggee/radar machine (any OSes) with the debugger machine (Win10).
(1) Insert the Captain DMA 75t board to the debuggee/radar machine.

(2) Connect the board to the debugger machine via a USB-c to USB-A cable. Connect the board to the debugger machine via a USB-c to USB-A cable.
* There are two USB-c ports on the 75t board. The one far away from the pci-e golden finger is for data transmition. The other one is for firmware flashing.
    
## 2. Install drivers on the debugger machine.
(1) Install the FPGA driver: FTD3XXDriver_WHQLCertified_1.3.0.8_Installer. (downloaded from the official discord server, or use the driver on https://phoenixdma.com/dma-quick-start-guide/)

(2) Re-plug the USB cable to the debugger machine. The "Device Manager" on the debugger machine should have the device "FTDI FT601 USB 3.0 Bridge Device" under "Universal Serial Bus controllers" now.

(3) Run BenchmarkTool-Atomic-v1.4.exe in the "DMA test.rar" with __admin privilege__ to test the DMA connection.

## 3. Run pcileech on the debugger machine
(1) Unzip [PCILeech_files_and_binaries_v4.18.1-win_x64-20240911.rar](https://github.com/ufrisk/pcileech/releases/download/v4.18/PCILeech_files_and_binaries_v4.18.1-win_x64-20240911.zip)

(2) Download [FTD3XXLibrary_v1.3.0.8.zip](https://ftdichip.com/wp-content/uploads/2023/11/FTD3XXLibrary_v1.3.0.8.zip) and put FTD3XX.dll and FTD3XX.lib to the pcileech directory above.

(3) Run pcilleech commands to access the memory of the debuggee machine. The Captain DMA board shows the blue light on DMA reading and the green light on idle.
* Example 1: "pcileech dump -min 0x4000 -max 0x8000"
* Example 2: "pcileech display -min 0x4000 -max 0x8000"


## References
[1] https://github.com/ufrisk/pcileech/wiki/PCILeech-on-Windows
    
