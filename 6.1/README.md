# Overlay for Device tree 

## Install dts overlay

To start with, I made a universal overlay dts file to enable (or disable) the cedar driver via armbian-config - NO need to compile the kernel or the whole distribution.

1. copy sun8i-h3-cedar-activate.dts file to some path on SBC and in console exec command:
```
sudo dtc -@ -I dts -O dtb -o /boot/dtb/overlay/sun8i-h3-cedar-activate.dtbo sun8i-h3-cedar-activate.dts
```
(there will be warnings, don't be alarmed and move on)

2. Use armbian-config to activate System->Hardware->cedar-activate our created profile:
```
sudo armbian-config
```
![deoptim@homeassistant_ ~ 01 02 2024 13_51_31](https://github.com/Deoptim/sunxi-cedar-mainline/assets/5656726/bcc46cf5-6524-468d-849a-fd8134a20a65)
Click Save then Back, in the window agree to Reboot

3. After a reboot, nothing will work without the cedar module, but the fact that the dts file was applied successfully will indicate that we have reserved CMA memory:
```
dmesg | grep CMA
[    0.000000] Reserved memory: created CMA memory pool at 0x57c00000, size 96 MiB
```
And the previous device is disabled:
```
dmesg | grep video-codec

```
(there should be nothing on the output)

## Compile module on SBC

The cedar_ve module itself is compiled on the board itself in seconds, we will not use cross compilation:

1. Now compile the cedar_ve module itself and install it in the single board itself:
```
sudo apt update
sudo apt install git build-essential linux-headers-current-sunxi
```

I will put the module in the ~/ (home user) folder you can do it in another folder:
```
cd ~/
git clone https://github.com/uboborov/sunxi-cedar-mainline
cd sunxi-cedar-mainline
```

2. Compile:
```
make KERNEL_SOURCE=/lib/modules/$(uname -r)/build
```

3. Install in the system:
```
sudo mkdir /lib/modules/$(uname -r)/kernel/drivers/staging/media/sunxi/cedar
sudo cp ./cedar_ve.ko /lib/modules/$(uname -r)/kernel/drivers/staging/media/sunxi/cedar/
sudo depmod -a
```

We can run it right away without rebooting:
```
sudo modprobe cedar_ve
```

4. Additionally, which was not mentioned anywhere, you should set permissions for /dev/cedar_dev and add it to the video group at boot, this is important for ex. motion/motioneye tool.
The contents of the file /etc/udev/rules.d/50-cedar.rules should be like this:
```
KERNEL=="cedar_dev", MODE="0660", GROUP="video"
```
