/*******************************************************
Chip type : ATmega16
Program type : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model : Small
External RAM size : 0
Data Stack size : 256
*******************************************************/
#include <mega16.h>
#include <delay.h>
#define Read_BIT(reg,bit) (reg&(1<<bit))>>bit
#define GND PORTD.7
#define VCC PORTC.4
#define led PORTD.1
#define SW PIND.2
unsigned char ic74155();
void main(void)
{
DDRD = 0x82;
PORTD = 0x04;
led = 0;
while (1)
 { 
 delay_ms(30);
 if (SW == 0){
 int check = ic74155();
 if (check == 1) led = 1;
 }
 }
}
unsigned char ic74155()
{

 signed char j,i;

 DDRA = 0x70;
 DDRB = 0x00;
 DDRC = 0x0f0;
 DDRD = 0x82;
 PORTA = 0;
 PORTC = 0;
 PORTD = 0x04;
 PORTB = 0;
 GND = 0;
 VCC = 1;
 PORTA.5 = 1; PORTC.6 = 1; //enables


 for (i = 0;i <= 3;i++)
 {
 PORTA.6 =Read_BIT(i,1);
 PORTC.7 =Read_BIT(i,0);

 for (j = 0; j <= 1;j++)
 {
 PORTA.4 = j;
 PORTC.5 = !j;
 PORTA.5 = 0;
 PORTC.6 = 0;

 delay_ms(30);
 if (((!PINA.7<<3)+ (!PIND.4<<2)+ (!PIND.5<<1)+(!PIND.6))!=(j<<i) ) return 0;
 delay_ms(30);
 if (((!PINB.0<<3)+ (!PINB.1<<2)+ (!PINB.2<<1)+(!PINB.3))!=(j<<i) ) return 0;
 PORTA.5 = 1;
 PORTC.5 = 1;
 }
 delay_ms(30);
 if (((!PINA.7<<3)+ (!PIND.4<<2)+ (!PIND.5<<1)+(!PIND.6))!=0 ) return 0;
 delay_ms(30);
 if (((!PINB.0<<3)+ (!PINB.1<<2)+ (!PINB.2<<1)+(!PINB.3))!=0 ) return 0;
 }


 VCC = 0;
 return 1;
}
 
 
 VCC = 0;
 return 1;
}