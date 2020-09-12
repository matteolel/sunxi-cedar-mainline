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

## UPD
For Linux kernel >= 5.x nodes **syscon** and **ve** must be chanded in **.dts** file:
```
syscon: system-control@1c00000 {
			compatible = "allwinner,sun8i-h3-system-control","syscon";
			reg = <0x01c00000 0x1000>;
			#address-cells = <1>;
			#size-cells = <1>;
			ranges;

			sram_c: sram@1d00000 {
				compatible = "mmio-sram";
				reg = <0x01d00000 0x80000>;
				#address-cells = <1>;
				#size-cells = <1>;
				ranges = <0 0x01d00000 0x80000>;

				ve_sram: sram-section@0 {
					compatible = "allwinner,sun8i-h3-sram-c1",
					 "allwinner,sun4i-a10-sram-c1";
					reg = <0x000000 0x80000>;
				};
			};
		};
```
```
ve: video-engine@01c0e000 {
			compatible = "allwinner,sunxi-cedar-ve";
			reg = <0x01c0e000 0x1000>,
			          <0x01c00000 0x10>,
			          <0x01c20000 0x800>;
			memory-region = <&cma_pool>;
			syscon = <&syscon>;
			clocks = <&ccu CLK_BUS_VE>, <&ccu CLK_VE>,
			         <&ccu CLK_DRAM_VE>;
			clock-names = "ahb", "mod", "ram";
			resets = <&ccu RST_BUS_VE>;
			interrupts = <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>;
			allwinner,sram = <&ve_sram 1>;
		};
```
