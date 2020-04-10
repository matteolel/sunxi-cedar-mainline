# sunxi cedar kernel module

Targeting mainline kernel - linux-4.11.y and higher.

## Changes

* reserved memory CMA below 256M is used for **dma_alloc_coherent** (see the device tree file) instead of ION allocator.
* mmap has been modified to support MACC and DMA memory.
* interrupt status code 0xB (AVC (h264 encoder)) has been added for Allwinner A20.
* video engine has been added to the device tree.
* MMAP cached area and cache cleaning support has been added (cache-v7.S). It increases the framerate twice the uncached one.

## Building

The first method quickly produces `.ko` module without building anything else.

Copy your `.config` file to the root of this repository and then run:

### On the target machine

```
make KERNEL_SOURCE=.../linux-source
```

### On the host machine (cross-compilation)

```
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- KERNEL_SOURCE=.../linux-source
```

Or whatever your `CROCC_COMPILE` prefix is.

### Other build option

Remove or rename `Makefile`:
```
mv Makefile Makefile.bak
```

And then execute:
```
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- KDIR=.../linux-source -f Makefile.linux
```
