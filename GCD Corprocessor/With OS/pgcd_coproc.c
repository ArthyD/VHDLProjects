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

#define PGCD_COPROC_BASEADDR    0x43C00000
#define PGCD_COPROC_REGION_SIZE 0xFFFF+1
#define X_OFFSET      0
#define Y_OFFSET      4
#define GO_OFFSET     8
#define VALID_OFFSET  12
#define RESULT_OFFSET 16
#define CYCLE_OFFSET  20

static int pgcd_coproc_major = 0;
module_param(pgcd_coproc_major, int, 0);

MODULE_AUTHOR ("IMT Atlantique");
MODULE_LICENSE("Dual BSD/GPL");

static void*        pgcd_coproc_addr;
static unsigned int pgcd_coproc_base_addr;
static unsigned int pgcd_coproc_region_size;

//============================================================================
//  /dev/pgcd_coproc file operations
//  read : return the current settings (MODE,SPEED)
//  write: write set the settings (MODE,SPEED)
//============================================================================
int pgcd_coproc_i_open (struct inode *inode, struct file *filp)
{
    printk(KERN_INFO "pgcd_coproc: device opened.\n");
    return 0;
}

int pgcd_coproc_i_release (struct inode *inode, struct file *filp)
{
    printk(KERN_INFO "pgcd_coproc: device closed\n");
    return 0;
}

ssize_t pgcd_coproc_i_read (struct file *filp, char __user *buf, size_t count, loff_t *f_pos)
{
    // Read registers
    char my[6];
    my[0] = ioread8(pgcd_coproc_addr + X_OFFSET);
    my[1] = ioread8(pgcd_coproc_addr + Y_OFFSET);
    my[2] = ioread8(pgcd_coproc_addr + GO_OFFSET);
    my[3] = ioread8(pgcd_coproc_addr + VALID_OFFSET);
    my[4] = ioread8(pgcd_coproc_addr + RESULT_OFFSET);
    my[5] = ioread8(pgcd_coproc_addr + CYCLE_OFFSET);
    copy_to_user(buf, my, 6);

    return 0;
}



ssize_t pgcd_coproc_i_write (struct file *filp, const char __user *buf, size_t count, loff_t *f_pos)
{
    // Write registers
    char my[3];
    copy_from_user(my, buf, 3);
    iowrite8(my[0], pgcd_coproc_addr + X_OFFSET);
    iowrite8(my[1], pgcd_coproc_addr + Y_OFFSET);
    iowrite8(my[2], pgcd_coproc_addr + GO_OFFSET);
    
    return count;
}

struct file_operations pgcd_coproc_i_fops = {
    .owner   = THIS_MODULE,
    .read    = pgcd_coproc_i_read,
    .write   = pgcd_coproc_i_write,
    .open    = pgcd_coproc_i_open,
    .release = pgcd_coproc_i_release,
};

//============================================================================
//  pgcd_coproc driver definition
//  - setup /dev/pgcd_coproc device
//  - protect the memory region
//  - io-remap the device BASE_ADDR
//  - setup led mode & speed
//============================================================================

static int pgcd_coproc_init(void)
{
    printk(KERN_INFO "Custom Module init..\n");

    int result;

    // get address and region size of axi registers
    pgcd_coproc_base_addr     = PGCD_COPROC_BASEADDR;
    pgcd_coproc_region_size   = PGCD_COPROC_REGION_SIZE;

    // here we register our device
    result = register_chrdev(pgcd_coproc_major, "pgcd_coproc", &pgcd_coproc_i_fops);
    if (result < 0)
    {
        printk(KERN_INFO "pgcd_coproc: can't get major number\n");
        return result;
    }

    // if the major number isn't fixed, the major is dynamic
    if (pgcd_coproc_major == 0)
        pgcd_coproc_major = result;

    // protect the memory region

    request_mem_region(pgcd_coproc_base_addr, pgcd_coproc_region_size, "pgcd_coproc");

    // remap the BASE_ADDR memory region

    pgcd_coproc_addr = ioremap(pgcd_coproc_base_addr,pgcd_coproc_region_size);

    iowrite8(0,pgcd_coproc_addr + GO_OFFSET);


    printk(KERN_INFO "Custom Module:init done");
    return 0;
}

static void pgcd_coproc_remove(void)
{
    // drop the /dev/pgcd_coproc entry
    unregister_chrdev(pgcd_coproc_major, "pgcd_coproc");

    // iounmap

    iounmap(pgcd_coproc_addr);

    // release protected memory

    release_mem_region(pgcd_coproc_base_addr, pgcd_coproc_region_size);

    printk(KERN_INFO "pgcd_coproc:       module cleaned ...\n");
}

module_init(pgcd_coproc_init);
module_exit(pgcd_coproc_remove);
