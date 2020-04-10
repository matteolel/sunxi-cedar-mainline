# Device tree patches

## Modifying kernel sources

You can either apply `orangepidts.patch` patch or copy `*.dts` and `*.dtsi` files to `arch/arm/boot/dts` directory in the linux source directory.

The patch includes changes only for Orange Pi One and Lite. To modify it for your device (e.g. PC) simply add

```
&ve {
	status = "okay";
};
```

to the end of the corresponding `*.dts` file.

## Installation

Run `make dtbs` in the root of the kernel source directory and use the resulting `*.dtb`.
