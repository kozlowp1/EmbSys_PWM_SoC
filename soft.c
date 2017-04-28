
#include <altera_avalon_pio_regs.h>
#include <stdio.h>
#include <system.h>
#include <io.h>
#include <inttypes.h>
#include <unistd.h>

int main() {
/*
 * The program moves the servo up and down
 * At first the period is loaded
 * Then the duty-cycle is changed in the loops
 */
	IOWR_8DIRECT(PWM_GEN_V2_0_BASE, 2, 255);
	int x;
	int x2;

do{
	for(x=10;x<250;x++){

	IOWR_8DIRECT(PWM_GEN_V2_0_BASE, 3, x);
	usleep(10000);
	}
	for(x=250;x>10;x--){
	IOWR_8DIRECT(PWM_GEN_V2_0_BASE, 3, x);
	usleep(20000);

	//read duty cycle
	//x = IORD_8DIRECT(PWM_GEN_V2_0_BASE, 1);
	//printf("duty cycle %d", x);
	//read period
	//x2 = IORD_8DIRECT(PWM_GEN_V2_0_BASE, 4);
	//printf("period %d", x2);
	}
	x2++;
}while(x2<10);

	while(1);

	return 0;
}
