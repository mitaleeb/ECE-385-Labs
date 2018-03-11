/*
 * main.c, the main c file for lab 7 of ece 385
 * Initial files provided by Professor Zuofu Cheng
 * Lab 7 c code by Dean Biskup and Mitalee Bharadwaj,
 * dbiskup2 and mitalee2. Spring 2018
 */

int main()
{
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x50; //make a pointer to access the PIO block
	volatile unsigned int *SW = (unsigned int*)0x40; // pointer to access switches
	volatile unsigned int *ACCU = (unsigned int*) 0x30;
	volatile unsigned int *RESET = (unsigned int*)0x20;

	*LED_PIO = 0; //clear all LEDs
	while ( (1+1) != 3) //infinite loop
	{
		// If ACCU is pressed
		/*if (*ACCU) {
			// We want to add whats in the switches to
			// the value shown on the LEDs
			*LED_PIO += *SW;
			*LED_PIO %= (unsigned int)256;
			while (*ACCU) {
				continue;
			}
		}

		// Clear LEDs if we hit reset
		if (*RESET) {
			*LED_PIO = 0;
		}*/


		// Part below given for blinking LED
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO |= 0x1; //set LSB
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO &= ~0x1; //clear LSB

	}
	return 1; //never gets here
}
