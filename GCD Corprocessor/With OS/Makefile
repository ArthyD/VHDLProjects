
obj-m	:=  pgcd_coproc.o axi_btns.o
PWD       := $(shell pwd)
KERNELDIR=/users/local/hw_tp3_completed/linux-xlnx/


CC=arm-linux-gnueabihf-gcc

default:appWithThreads
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

clean:
	rm -rf *.o *~ core .*.cmd *.ko *.mod.c .tmp_versions Module.symvers modules.order app appWithThreads test_mmap thread_app

app:app.c
	$(CC) app.c -o app

appWithThreads:appWithThreads.c
	$(CC) appWithThreads.c -pthread -o appWithThreads

test_mmap:test_mmap.c
	$(CC) test_mmap.c -o test_mmap
