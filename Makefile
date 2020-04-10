ifneq (${KERNELRELEASE},)
	obj-m += cedar_ve.o
else
	ARCH=
	ifneq (${ARCH},)
		export ARCH
	endif

	CROSS_COMPILE=
	ifneq (${ARCH},)
		export CROSS_COMPILE
	endif

	KERNEL_SOURCE=/usr/src/linux
	PWD:=$(shell pwd)

default:
	${MAKE} -C ${KERNEL_SOURCE} M=${PWD} modules

clean:
	${MAKE} -C ${KERNEL_SOURCE} M=${PWD} clean
endif
