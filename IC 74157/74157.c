#include <mega16.h>
#include <delay.h>

#define Read_BIT(reg,bit) (reg&(1<<bit))>>bit

#define GND PORTD.7
#define VCC PORTC.4
#define led PORTD.1
#define SW PIND.2

unsigned char ic74157();
void main(void)
{
 DDRD = 0x02; 
 PORTD = 0x04; 
 led = 0;

while (1)
      {
        if (SW == 0){
        int check = ic74157();
        if (check == 1) led = 1;
        }
      }
}

unsigned char ic74157()
{
  signed char i;
  unsigned char D = 0x05 ;
  PORTA = 0;
  PORTC = 0;
  PORTD = 0x04;
  PORTB = 0;
  DDRA = 0x70;
  PORTA = 0;
  DDRC = 0xF0;
  PORTC = 0;
  DDRD &=0x0F;
  DDRD |= 0xB0;
  PORTD &= 0x0F;
  DDRB = 0X06;
  PORTB = 0;
  GND = 0;
  VCC = 1;
  PORTC.5 = 1;  //enables
  PORTA.5=0;PORTA.6=0;PORTD.4=0; PORTD.5=0;PORTC.6=0;PORTC.7=0;PORTB.1=0; PORTB.2=0;
  PORTA.4=0;
  // input 0101
  for (i = 0;i <= 1;i++)
      {
       PORTC.6 =Read_BIT(D,3); PORTB.1 =Read_BIT(D,2);PORTD.4 =Read_BIT(D,1);PORTA.5 =Read_BIT(D,0);
        PORTC.5 = 0;
        delay_ms(30);
        if (((PINB.0<<3)+ ( PINB.3<<2) + (PIND.6<<1) + (PINA.7)) != D )
        return 0;
        PORTC.5 = 1;
        delay_ms(30);
        if ((PINB.0!=0) & (PINB.3!=0) & (PIND.6 !=0) & (PINA.7!=0))
        return 0;
        D^= 0x0F;
      }
    D = 0x05 ;
    PORTA.5=0;PORTA.6=0;PORTD.4=0; PORTD.5=0;PORTC.6=0;PORTC.7=0;PORTB.1=0; PORTB.2=0;
    PORTA.4=1;
  // input 0101
  for (i = 0;i <= 1;i++)
      {
       PORTC.7 =Read_BIT(D,3); PORTB.2 =Read_BIT(D,2);PORTD.5 =Read_BIT(D,1);PORTA.6 =Read_BIT(D,0);
        PORTC.5 = 0;
        delay_ms(30);
        if (((PINB.0<<3)+ ( PINB.3<<2) + (PIND.6<<1) + (PINA.7)) != D )
        return 0;
        PORTC.5 = 1;
        delay_ms(30);
        if ((PINB.0!=0) & (PINB.3!=0) & (PIND.6 !=0) & (PINA.7!=0))
        return 0;
        D^= 0x0F;
      }
      VCC = 0;
     return 1;
}