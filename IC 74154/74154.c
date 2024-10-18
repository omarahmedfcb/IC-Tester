#include <mega16.h>
#include <delay.h>
#define Read_BIT(reg,bit) (reg&(1<<bit))>>bit
#define GND PORTD.7
#define VCC PORTC.0
#define led PORTD.1
#define SW PIND.2

unsigned char ic74154();
void main(void)
{
 DDRD = 0x02;
 PORTD = 0x04;
 led = 0;

while (1)
      {
        if (SW == 0){
        int check = ic74154();
        if (check == 1) led = 1;
        }
      }
}

unsigned char ic74154()
{

  signed char j,i;
  unsigned char D = 0xFE,x,y,y2 ;

  DDRA = 0x00;
  PORTA = 0;
  DDRC = 0x7F;
  PORTC = 0;
  DDRB = 0x00;
  PORTB = 0;
  DDRD = 0x82;
  PORTD &=0x0F;
  GND = 0;
  VCC = 1;
  PORTC.5 = 0; PORTC.6 = 0;  //enables

  x = 1;
  for (i = 0 ; i <= 15 ;i++)
  {
      if (i == 7 ) {
    x = 1;
    continue;
    }

    PORTC.4 =Read_BIT(i,3);PORTC.3 =Read_BIT(i,2);PORTC.2 =Read_BIT(i,1);PORTC.1 =Read_BIT(i,0);
    delay_ms(50);
    y = (!PINA.7<<7 )+(!PINA.6<<6 )+(!PINA.5<<5 )+(!PINA.4<<4 )+(!PINA.3<<3 )+(!PINA.2<<2)+(!PINA.1<<1)+!PINA.0;
    y2 = (!PINC.7<<7 )+(!PINB.0<<6 )+(!PINB.1<<5 )+(!PINB.2<<4 )+(!PINB.3<<3 )+(!PIND.6<<2 )+(!PIND.5<<1 )+(!PIND.4);


    if(y==x&& i< 8)
    {
     //x= rotateLeft(x, 1);
     x = x * 2;
      continue;
    }

    else if (y2 == x)
       {
       x = (1<<i-7);
        continue;
       }
    else
    {
      return 0;
    }

  }
 return 1;

}
