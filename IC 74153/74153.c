
#include <mega16.h>
#include <delay.h>
#include <stdio.h>


#define Read_BIT(reg,bit) (reg&(1<<bit))>>bit

#define GND PORTD.7
#define VCC PORTC.4
#define led PORTD.1
#define SW PIND.2

unsigned char ic74153();
void main(void)
{
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;
PORTD = 0x04; 

DDRD = 0x00;
PORTD = 0x04;
led = 0;
 //DDRB = 1;

while (1)
      {
        if (SW == 0){
        int check = ic74153();
        if (check == 1) puts("ic74153");
        delay_ms(500);
        }
      }
}

unsigned char ic74153()
{

  signed char j,i;
  unsigned char D = 0x09 , x;
  DDRA = 0xF0;
  PORTA = 0;
  DDRC = 0xF0;
  PORTC = 0;
  DDRD =0xB2;
  //DDRD |= 0xB0;
  PORTD = 0x04;
  DDRB = 0X07;
  PORTB = 0;
  GND = 0;
  VCC = 1;
  PORTA.4 = 1; PORTC.5 = 1;  //enables
  // input 1001

  for (i = 0;i <= 1;i++)
      {
       PORTA.6 =Read_BIT(D,3);PORTA.7 =Read_BIT(D,2);PORTD.4 =Read_BIT(D,1);PORTD.5 =Read_BIT(D,0);
       x = 0;
      for (j = 3; j >= 0;j--)
      {
        PORTA.5 = Read_BIT(j,1);
        PORTC.6 = Read_BIT(j,0);
        PORTA.4 = 0;
        delay_ms(30);

        x = (x << 1) | PIND.6;
        PORTA.4 = 1 ; 
        delay_ms(30);
        if (PIND.6 != 0){
         return 0;
        }

      }
      delay_ms(30);
      if (x != D) {
         return 0;
        }
      D^= 0x0F;
      }

      D = 0x09 ; x=0;
      for (i = 0;i <= 1;i++)
      {
       PORTC.7 =Read_BIT(D,3);PORTB.0 =Read_BIT(D,2);PORTB.1 =Read_BIT(D,1);PORTB.2 =Read_BIT(D,0);
       x = 0;
      for (j = 3; j >= 0;j--)
      {
        PORTA.5 = Read_BIT(j,1);
        PORTC.6 = Read_BIT(j,0);
        PORTC.5 = 0;
        delay_ms(30);

        x = (x << 1) | PINB.3;
        PORTC.5 =1;
        delay_ms(30);
        if (PINB.3 != 0) {
         return 0;
        }

      }
      if (x != D) {
         return 0;
        }
      D^= 0x0F;

      }
      VCC = 0;
     return 1;
}
