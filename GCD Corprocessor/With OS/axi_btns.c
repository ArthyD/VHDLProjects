#include <linux/wait.h>
#include <linux/sched.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/uaccess.h>	// copy_from_user
#include <asm/io.h>		// IO Read/Write Functions
#include <linux/proc_fs.h>	// Proc File System Functions
#include <linux/seq_file.h>	// Sequence File Operations
#include <linux/ioport.h>	// release_mem_region
#include <linux/interrupt.h>	// interrupt
#include <linux/irq.h>
#include <linux/delay.h>
#include <linux/cdev.h>
#include <linux/platform_device.h>
#include <linux/mod_devicetable.h>


#define GIE_OFFSET 0x011C
#define IER_OFFSET 0x0128
#define ISR_OFFSET 0x0120

int irq; // the IRQ number

static int btns_major = 0;
module_param(btns_major, int, 0);

MODULE_AUTHOR ("IMT Atlantique");
MODULE_LICENSE("Dual BSD/GPL");

static          int btns_flag = 0;
static void*        btns_addr;
static unsigned int btns_base_addr;
static unsigned int btns_region_size;

int can_read = 0;

DECLARE_WAIT_QUEUE_HEAD(btns_wq);

static irqreturn_t axi_btns_irq_handler(int irq, void * arg2);

//============================================================================
//  /dev/btns file operations
//  read : return the pressed button
//============================================================================
int btns_i_open (struct inode *inode, struct file *filp)
{

    printk(KERN_INFO "btns: device opened.\n");
    return 0;
}

int btns_i_release (struct inode *inode, struct file *filp)
{
    printk(KERN_INFO "btns: device closed\n");
    return 0;
}

ssize_t btns_i_read (struct file *filp, char __user *buf, size_t count, loff_t *f_pos)
{
    
    char my[1];
    my[0] = ioread8(btns_addr);
    copy_to_user(buf, my, 1);


    wait_event_interruptible(btns_wq,can_read != 0);
    can_read = 0;
    return count;
}

ssize_t btns_i_write (struct file *filp, const char __user *buf, size_t count,	loff_t *f_pos)
{

    return count;
}

struct file_operations btns_i_fops = {
    .owner   = THIS_MODULE,
    .read    = btns_i_read,
    .write   = btns_i_write,
    .open    = btns_i_open,
    .release = btns_i_release,
};

//============================================================================
//  axi_btns driver definition
//============================================================================

static int axi_btns_of_probe(struct platform_device *ofdev)
{
    int result;
    struct resource *btns_irq_resource;
    struct resource *btns_addr_resource;

    btns_irq_resource = platform_get_resource(ofdev, IORESOURCE_IRQ, 0);
    if (!btns_irq_resource) {
        printk(KERN_INFO "could not get platform IRQ resource.\n");
        return -1;
    }

    // save the returned IRQ, to be used in request_irq
    irq = btns_irq_resource->start;
    printk(KERN_INFO "IRQ read from DTS entry as %d\n", irq);
 
    // request irq
    result = request_irq(irq,&axi_btns_irq_handler, btns_flag, "btns", "btns");
    
    if (result<0) {
        printk(KERN_INFO "Error with request IRQ.\n");
        return result;
    } else {
        printk(KERN_INFO "Success with request IRQ.\n");
    }

    // get address and region size of axi registers
    btns_addr_resource = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
    btns_base_addr     = btns_addr_resource->start;
    btns_region_size   = resource_size(btns_addr_resource);
    printk(KERN_INFO "Btns addr: %x\n", btns_base_addr  );
    printk(KERN_INFO "Btns size: %x\n", btns_region_size);

    // here we register our device
    result = register_chrdev(btns_major, "btns", &btns_i_fops);
    if (result < 0)
    {
        printk(KERN_INFO "btn: can't get major number\n");
        return result;
    }

    // if the major number isn't fix, the major is dynamic
    if (btns_major == 0)
        btns_major = result;

    // protect the memory region

    request_mem_region(btns_base_addr, btns_region_size, "btns");

    // remap the BASE_ADDR memory region

    btns_addr = ioremap(btns_base_addr,btns_region_size);

    // enable the Axi GPIO interrrupt

    iowrite32(0x1, btns_addr + IER_OFFSET);

    iowrite32(0x80000000, btns_addr + GIE_OFFSET); // 1 << 31


    //enable_irq(irq);

    return 0;
}

static int axi_btns_of_remove(struct platform_device *of_dev)
{
    // drop the /dev/btns entry
    unregister_chrdev(btns_major, "btns");

    // release protected memory

    iounmap(btns_addr);
    iowrite32(0x0, btns_addr + GIE_OFFSET);
    iowrite32(0x0, btns_addr + IER_OFFSET);

    // free irq

    free_irq(irq, "btns");

    // iounmap
    printk(KERN_INFO "btns:       module cleaned ...\n");

    release_mem_region(btns_base_addr, btns_region_size);
    return 0;
}

static irqreturn_t axi_btns_irq_handler(int irq, void * arg2)
{   
    //Clear Interrupt
    iowrite32(0x1, btns_addr + ISR_OFFSET);
    // interruption
    //printk(KERN_INFO "btns: interrupt\n");

    wake_up_interruptible(&btns_wq);
    can_read = 1;

    return IRQ_HANDLED;
}

static const struct of_device_id axi_btns_of_match[] = {
    { .compatible = "imt,axi-btns" },
    { /* end of list */ },
};

MODULE_DEVICE_TABLE(of, axi_btns_of_match);

static struct platform_driver axi_btns_of_driver = {
    .probe      = axi_btns_of_probe,
    .remove     = axi_btns_of_remove,
    .driver = {
        .name = "axi_btns",
        .owner = THIS_MODULE,
        .of_match_table = axi_btns_of_match,
    },
};

module_platform_driver(axi_btns_of_driver);
