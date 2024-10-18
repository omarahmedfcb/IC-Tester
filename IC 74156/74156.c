
#include <mega16.h>
#include <delay.h>

#define Read_BIT(reg,bit) (reg&(1<<bit))>>bit

#define GND PORTD.7
#define VCC PORTC.4
#define led PORTD.1
#define SW PIND.2

unsigned char ic74156();
void main(void)
{
 DDRD = 0x82;
 PORTD = 0x04;
 led = 0;

while (1)
      {  
       delay_ms(30);
        if (SW == 0){
        int check = ic74156();
        delay_ms(30);
        if (check == 1) led = 1;
        }
      }
}
unsigned char ic74156()
{
  
  signed char j,i;
  DDRA = 0x70;
  DDRB = 0x00;
  DDRC = 0x0F0;
  DDRD = 0x82;
  GND = 0;  
  VCC = 1;
  PORTA.5 = 1; PORTC.6 = 1;  //enables 
  // input 1001
  
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
        
       //loadmodeon;
       PORTA = PORTA | 0x80;
       PORTD = PORTD | 0x70;
       PORTB = PORTB | 0x0f; 
       delay_ms(30);
        
        if (((!PINA.7<<3)+ (!PIND.4<<2)+ (!PIND.5<<1)+(!PIND.6))!=(j<<i) ) return 0;
        delay_ms(30);
        if (((!PINB.0<<3)+ (!PINB.1<<2)+ (!PINB.2<<1)+(!PINB.3))!=(j<<i) ) return 0;
       
       PORTA &= 0x7F;
       PORTD &= 0x8F;
       PORTB &= 0xF0;
       
       delay_ms(10); 
       
        
         PORTA.5 = 1;
         PORTC.6 = 1;        
       }  
       PORTA = PORTA | 0x80;
       PORTD = PORTD | 0x70;
       PORTB = PORTB | 0x0f;
        delay_ms(30);
        if (((!PINA.7<<3)+ (!PIND.4<<2)+ (!PIND.5<<1)+(!PIND.6))!=0 ) return 0;
        delay_ms(30);
        if (((!PINB.0<<3)+ (!PINB.1<<2)+ (!PINB.2<<1)+(!PINB.3))!=0 ) return 0;
       
        
       PORTA &= 0x7F;
       PORTD &= 0x8F;
       PORTB &= 0xF0;
     }
        
      VCC = 0;
     return 1;
}
