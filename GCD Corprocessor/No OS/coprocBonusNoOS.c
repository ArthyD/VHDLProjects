#include <stdio.h>
#include "xparameters.h"
#include "xgpio.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "xtmrctr.h"
#include "xtmrctr_l.h"
#include "pgcd_coproc.h"

/************************** Goal of this program ******************************/
/*
 * The following program calculate the PGCD between two operands.
 * The operands are chosen by the user using the switches on the board.
 * the switches are mapped as follow : op1 on first 4 bits op2 on last 4 bits
 * The LSB for the 2 operands are directed towards the 5 buttons.
 *
 * The GO signal is triggered by pushing one button.
 *
 * The result is displayed on the leds and in the serial port.
 *
 */

/************************** Constant Definitions *****************************/
/*
 * The following constant maps to the name of the hardware instances that
 * were created in the EDK XPS system.
 */

#define INTC_DEVICE_ID	XPAR_PS7_SCUGIC_0_DEVICE_ID
#define INTC_PUSH_INTERRUPT_ID	XPAR_FABRIC_GPIO_0_VEC_ID
#define INTC_SWITCH_INTERRUPT_ID	XPAR_FABRIC_GPIO_1_VEC_ID

#define INTC		XScuGic
#define INTC_HANDLER	XScuGic_InterruptHandler
#define PUSH_INTERRUPT XGPIO_IR_CH1_MASK
#define SWITCH_INTERRUPT XGPIO_IR_CH1_MASK


/************************** Variable Definitions *****************************/

XGpio push, swtch, pgcd_coproc;
u32 result;
u32 calculationTime;
u32 pgcd;
u32 valid;
u8 op1;
u8 op2;

int SetupInterruptSystem();
static INTC Intc;


int main() {

	xil_printf("-- Start of the Program --\r\n");

	/*
	 * Initialize each peripheral so that it's ready to use,
	 * specify the device ID that is generated in xparameters.h
	 */
	XGpio_Initialize(&swtch, XPAR_SWITCHES_DEVICE_ID);
	XGpio_Initialize(&push, XPAR_BUTTONS_DEVICE_ID);

	PGCD_COPROC_mWriteReg (XPAR_PGCD_COPROC_0_S_AXI_BASEADDR, PGCD_COPROC_S_AXI_SLV_REG2_OFFSET, 0x00);
	PGCD_COPROC_mWriteReg (XPAR_PGCD_COPROC_0_S_AXI_BASEADDR, PGCD_COPROC_S_AXI_SLV_REG0_OFFSET, 0x5);
	PGCD_COPROC_mWriteReg (XPAR_PGCD_COPROC_0_S_AXI_BASEADDR, PGCD_COPROC_S_AXI_SLV_REG1_OFFSET, 0x6);


	//Setup the interrupts such that interrupt processing can occur.
	SetupInterruptSystem();

	while (1) { // an empty waiting loop!!!

	}

	xil_printf("---Exiting main---\n\r");

	return 0;
}



void pushIsr(void *InstancePtr) {
	XGpio *GpioPtr = (XGpio *) InstancePtr;

	// Disable the interrupt
	XGpio_InterruptDisable(GpioPtr, PUSH_INTERRUPT);

	// Processing
	//buttons_check = XGpio_DiscreteRead(GpioPtr, PUSH_INTERRUPT);
		PGCD_COPROC_mWriteReg (XPAR_PGCD_COPROC_0_S_AXI_BASEADDR, PGCD_COPROC_S_AXI_SLV_REG2_OFFSET, 0x1);
				PGCD_COPROC_mWriteReg (XPAR_PGCD_COPROC_0_S_AXI_BASEADDR, PGCD_COPROC_S_AXI_SLV_REG2_OFFSET, 0x00);
				valid = PGCD_COPROC_mReadReg (XPAR_PGCD_COPROC_0_S_AXI_BASEADDR, PGCD_COPROC_S_AXI_SLV_REG3_OFFSET);
				while (valid != 0x1) { // an empty waiting loop!!!
					valid = PGCD_COPROC_mReadReg (XPAR_PGCD_COPROC_0_S_AXI_BASEADDR, PGCD_COPROC_S_AXI_SLV_REG3_OFFSET);

				}

				xil_printf("operand 1 :%d \r\n",op1);
				xil_printf("operand 2 :%d \r\n",op2);
				result = PGCD_COPROC_mReadReg (XPAR_PGCD_COPROC_0_S_AXI_BASEADDR, PGCD_COPROC_S_AXI_SLV_REG4_OFFSET);
				xil_printf("result = %d \r\n", result);

				calculationTime = PGCD_COPROC_mReadReg (XPAR_PGCD_COPROC_0_S_AXI_BASEADDR, PGCD_COPROC_S_AXI_SLV_REG5_OFFSET);
				xil_printf("time = %d \r\n", calculationTime);


	// Clear the interrupt
	XGpio_InterruptClear(GpioPtr, PUSH_INTERRUPT);

	//Enable the interrupt
	XGpio_InterruptEnable(GpioPtr, PUSH_INTERRUPT);

	xil_printf("Interrupt Push Button Processed \r\n");

}

void swtchIsr(void *InstancePtr) {
	u32 swtch_check;  // Paste near top of function, with variables
	XGpio *GpioPtr = (XGpio *) InstancePtr;

	op1 =swtch_check & 0x0F;
	op2 =(swtch_check>>4);

	//Disable the interrupt
	XGpio_InterruptDisable(GpioPtr, SWITCH_INTERRUPT);

	// Processing
	swtch_check = XGpio_DiscreteRead(&swtch, SWITCH_INTERRUPT);
	xil_printf("swtch_check  = %x\r\n", swtch_check);
	PGCD_COPROC_mWriteReg(XPAR_PGCD_COPROC_0_S_AXI_BASEADDR,
				PGCD_COPROC_S_AXI_SLV_REG0_OFFSET,
				op1);

	PGCD_COPROC_mWriteReg(XPAR_PGCD_COPROC_0_S_AXI_BASEADDR,PGCD_COPROC_S_AXI_SLV_REG1_OFFSET,op2);



	// Clear the interrupt
	XGpio_InterruptClear(GpioPtr, SWITCH_INTERRUPT);

	//Enable the interrupt
	XGpio_InterruptEnable(GpioPtr, SWITCH_INTERRUPT);

	xil_printf("Interrupt Slide Switches Processed \r\n");

}

/****************************************************************************/
/**
 * This function sets up the interrupt system for the example.  The processing
 * contained in this funtion assumes the hardware system was built with
 * and interrupt controller.
 *
 * @param	None.
 *
 * @return	A status indicating XST_SUCCESS or a value that is contained in
 *		xstatus.h.
 *
 * @note		None.
 *
 *****************************************************************************/
int SetupInterruptSystem() {
	int Result;
	INTC *IntcInstancePtr = &Intc;

	XScuGic_Config *IntcConfig;

	/*
	 * Initialize the interrupt controller driver so that it is ready to
	 * use.
	 */
	IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
	if (NULL == IntcConfig) {
		return XST_FAILURE;
	}

	Result = XScuGic_CfgInitialize(IntcInstancePtr, IntcConfig,
			IntcConfig->CpuBaseAddress);
	if (Result != XST_SUCCESS) {
		return XST_FAILURE;
	}

	XScuGic_SetPriorityTriggerType(IntcInstancePtr, INTC_SWITCH_INTERRUPT_ID,
			0xA0, 0x3);
	XScuGic_SetPriorityTriggerType(IntcInstancePtr, INTC_PUSH_INTERRUPT_ID,
			0xA0, 0x3);
	/*
	 * Connect the interrupt handler that will be called when an
	 * interrupt occurs for the device.
	 */
	Result = XScuGic_Connect(IntcInstancePtr, INTC_SWITCH_INTERRUPT_ID,
			(Xil_ExceptionHandler) swtchIsr, &swtch);
	if (Result != XST_SUCCESS) {
		return Result;
	}

	Result = XScuGic_Connect(IntcInstancePtr, INTC_PUSH_INTERRUPT_ID,
			(Xil_ExceptionHandler) pushIsr, &push);
	if (Result != XST_SUCCESS) {
		return Result;
	}

	//Enable the interrupt for the GPIO device.
	XScuGic_Enable(IntcInstancePtr, INTC_PUSH_INTERRUPT_ID);
	XScuGic_Enable(IntcInstancePtr, INTC_SWITCH_INTERRUPT_ID);

	// Enable the GPIO channel interrupts
	XGpio_InterruptEnable(&swtch, SWITCH_INTERRUPT);
	XGpio_InterruptEnable(&push, PUSH_INTERRUPT);
	XGpio_InterruptGlobalEnable(&swtch);
	XGpio_InterruptGlobalEnable(&push);

	// Initialize the exception table and register the interrupt
	// controller handler with the exception table
	Xil_ExceptionInit();

	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler) INTC_HANDLER, IntcInstancePtr);

	/* Enable non-critical exceptions */
	Xil_ExceptionEnable();

	return XST_SUCCESS;
}
