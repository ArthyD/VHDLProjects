
#include <stdio.h>
#include "xparameters.h"
#include "xgpio.h"
#include "xscugic.h"
#include "xil_exception.h"

/************************** Constant Definitions *****************************/
/*
 * The following constant maps to the name of the hardware instances that
 * were created in the EDK XPS system.
 */

#define INTC_DEVICE_ID	XPAR_PS7_SCUGIC_0_DEVICE_ID
#define INTC_PUSH_INTERRUPT_ID	XPAR_FABRIC_GPIO_0_VEC_ID
#define INTC_SWITCH_INTERRUPT_ID	XPAR_FABRIC_GPIO_2_VEC_ID
#define INTC		XScuGic
#define INTC_HANDLER	XScuGic_InterruptHandler
#define PUSH_INTERRUPT XGPIO_IR_CH1_MASK
#define SWITCH_INTERRUPT XGPIO_IR_CH1_MASK
/************************** Variable Definitions *****************************/
int SetupInterruptSystem();
void pushIsr(void *InstancePtr);
void swtchIsr(void *InstancePtr);
/*
 * The following are declared globally so they are zeroed and so they are
 * easily accessible from a debugger
 */

XGpio push, swtch, threshold, mode; /* The Instance of the GPIO Drivers */
/* The Instance of the Interrupt Controller Driver */
static INTC Intc;
volatile u32 brightness;
int thresh =4000;

int main() {

	int swtch_check;

	xil_printf("-- Start of the Program --\r\n");
	/*
	 * Initialize the GPIO driver
	 */
	XGpio_Initialize(&swtch, XPAR_SWITCHES_DEVICE_ID);
	XGpio_SetDataDirection(&swtch, 1, 0xffffffff); // configurer la direction en entr�e

	XGpio_Initialize(&push, XPAR_BTTNS_DEVICE_ID);
	XGpio_SetDataDirection(&push, 1, 0xffffffff); // configurer la direction en entr�e

	XGpio_Initialize(&threshold, XPAR_THRESHOLD_CTRL_DEVICE_ID);
	XGpio_SetDataDirection(&threshold, 1, 0x00000000); // configurer la direction en sortie

	XGpio_Initialize(&mode, XPAR_MODE_CTRL_DEVICE_ID);
	XGpio_SetDataDirection(&mode, 1, 0x00000000); // configurer la direction en sortie
	// Read the switches
	swtch_check = XGpio_DiscreteRead(&swtch, 1);

	XGpio_DiscreteWrite(&mode, 1, (swtch_check-1)/2);
	XGpio_DiscreteWrite(&threshold, 1, thresh);

	/*
	 * Setup the interrupts such that interrupt processing can occur.
	 */
	SetupInterruptSystem();


	while (1) {

	}

	xil_printf("---Exiting main---\n\r");

	return 0;
}


void pushIsr(void *InstancePtr) {
	u32 push_check;
	XGpio *GpioPtr = (XGpio *) InstancePtr;

	// Disable the interrupt
	XGpio_InterruptDisable(GpioPtr,PUSH_INTERRUPT);

	// Code pour lire les boutons, etc.
	push_check = XGpio_DiscreteRead(&push, PUSH_INTERRUPT);
	if(push_check== 0x10){
		if(thresh <4090){
			thresh+=10;
			xil_printf("Threshold : %d \r\n", thresh);
		}
	}
	if(push_check== 0x02){
		if(thresh >10){
			thresh-=10;
		}
		xil_printf("Threshold : %d \r\n", thresh);
	}
	XGpio_DiscreteWrite(&threshold, 1, thresh);
	// Clear the interrupt
	XGpio_InterruptClear(GpioPtr,PUSH_INTERRUPT);


	//Enable the interrupt
	XGpio_InterruptEnable(GpioPtr,PUSH_INTERRUPT);


	xil_printf("Interrupt Push Button Processed \r\n");

}

void swtchIsr(void *InstancePtr) {
	u32 swtch_check;  // Paste near top of function, with variables
	XGpio *GpioPtr = (XGpio *) InstancePtr;

	// Disable the interrupt
	XGpio_InterruptDisable(GpioPtr,SWITCH_INTERRUPT);

	// Processing
	swtch_check = XGpio_DiscreteRead(&swtch, SWITCH_INTERRUPT);
	xil_printf("mode  = %x\r\n", (swtch_check-1)/2);
	XGpio_DiscreteWrite(&mode, 1, (swtch_check-1)/2);

	// Clear the interrupt
	XGpio_InterruptClear(GpioPtr,SWITCH_INTERRUPT);


	//Enable the interrupt
	XGpio_InterruptEnable(GpioPtr,SWITCH_INTERRUPT);


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


	// Enable the GPIO channel interrupts inside the GPIO peripheral controller
	XScuGic_Enable(IntcInstancePtr, INTC_PUSH_INTERRUPT_ID);
	XScuGic_Enable(IntcInstancePtr, INTC_SWITCH_INTERRUPT_ID);

	// Enable the GPIO channel interrupts

	XGpio_InterruptEnable(&push,PUSH_INTERRUPT);
	XGpio_InterruptGlobalEnable(&push);
	XGpio_InterruptEnable(&swtch,SWITCH_INTERRUPT);
	XGpio_InterruptGlobalEnable(&swtch);


	Xil_ExceptionInit();

	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler) INTC_HANDLER, IntcInstancePtr);

	/* Enable non-critical exceptions */
	Xil_ExceptionEnable();

	return XST_SUCCESS;
}

