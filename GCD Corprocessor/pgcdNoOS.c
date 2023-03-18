#include <stdio.h>
#include "xparameters.h"
#include "xgpio.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "xtmrctr.h"
#include "xtmrctr_l.h"
#include "pgcd_coproc.h"



int main() {

	xil_printf("-- Start of the Program --\r\n");
	u32 pgcd;

	PGCD_COPROC_mWriteReg (XPAR_PGCD_COPROC_0_S_AXI_BASEADDR, PGCD_COPROC_S_AXI_SLV_REG2_OFFSET, 0x00);
	PGCD_COPROC_mWriteReg (XPAR_PGCD_COPROC_0_S_AXI_BASEADDR, PGCD_COPROC_S_AXI_SLV_REG0_OFFSET, 60);
	PGCD_COPROC_mWriteReg (XPAR_PGCD_COPROC_0_S_AXI_BASEADDR, PGCD_COPROC_S_AXI_SLV_REG1_OFFSET, 30);
	PGCD_COPROC_mWriteReg (XPAR_PGCD_COPROC_0_S_AXI_BASEADDR, PGCD_COPROC_S_AXI_SLV_REG2_OFFSET, 0x1);

	while (PGCD_COPROC_mReadReg (XPAR_PGCD_COPROC_0_S_AXI_BASEADDR, PGCD_COPROC_S_AXI_SLV_REG3_OFFSET) != 0x1) { // an empty waiting loop!!!


	}
	u32 result;
	u32 calculationTime;
	result = PGCD_COPROC_mReadReg (XPAR_PGCD_COPROC_0_S_AXI_BASEADDR, PGCD_COPROC_S_AXI_SLV_REG4_OFFSET);
	xil_printf("result = %d \r\n", result);
	PGCD_COPROC_mWriteReg (XPAR_PGCD_COPROC_0_S_AXI_BASEADDR, PGCD_COPROC_S_AXI_SLV_REG2_OFFSET, 0x00);
	calculationTime = PGCD_COPROC_mReadReg (XPAR_PGCD_COPROC_0_S_AXI_BASEADDR, PGCD_COPROC_S_AXI_SLV_REG5_OFFSET);
	xil_printf("time = %d \r\n", calculationTime);

	xil_printf("---Exiting main---\n\r");

	return 0;
}



