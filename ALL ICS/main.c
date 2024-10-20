#include <mega16.h>
#include <stdio.h>
#include <delay.h>

#define Read_BIT(reg,bit) (reg&(1<<bit))>>bit

#define GND PORTD.7
#define VCC PORTC.4
#define SW PIND.2
#define GND2 PORTD.7
#define VCC2 PORTC.0
unsigned char ic74153();
unsigned char ic74154();
unsigned char ic74155();
unsigned char ic74156();
unsigned char ic74157();
unsigned char ic74158();
void ic_test();


void main(void)
{
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;
PORTD = 0x04;


while (1)
      {
      if (SW == 0)
      {
       ic_test();
       delay_ms(500);
      }
}
}


void ic_test()
{
    char check = 0;
    check = ic74153();
    if (check == 1)
       {
        puts("IC 74153\r");
        return;
       }
    check = ic74155();
    if (check == 1)
       {
        puts("IC 74155\r");
        return;
       }
    check = ic74156();
    if (check == 1)
       {
        puts("IC 74156\r");
        return;
       }
    check = ic74157();
    if (check == 1)
       {
        puts("IC 74157\r");
        return;
       }
    check = ic74158();
    if (check == 1)
       {
        puts("IC 74158\r");
        return;
       }
    check = ic74154();
    if (check == 1)
       {
        puts("IC 74154\r");
        return;
       }

       puts("Not Defined\r");
}

unsigned char ic74153()
{

  signed char j,i;
  unsigned char D = 0x09 , x;
  DDRA = 0xF0;
  PORTA = 0;
  DDRC = 0xF0;
  PORTC = 0;
  DDRD &=0x0F;
  DDRD |= 0xB0;
  PORTD &= 0x0F;
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


unsigned char ic74155()
{

 signed char j,i;

 DDRA = 0x70;
 DDRB = 0x00;
 DDRC = 0x0f0;
 DDRD = 0x80;
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

unsigned char ic74156()
{
  
  signed char j,i;
  DDRA = 0x70;
  DDRB = 0x00;
  DDRC = 0x0F0;
  DDRD = 0x82;
  PORTA = 0;
  PORTC = 0;
  PORTD = 0x04;
  PORTB = 0;
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
       //PINA.3=1;PINA.4=1;PINA.5=1;PINA.6=1;  PINC.4=1;PINC.5=1;PINC.6=1;PINC.7=1;
        
        if (((!PINA.7<<3)+ (!PIND.4<<2)+ (!PIND.5<<1)+(!PIND.6))!=(j<<i) ) return 0;
        delay_ms(30);
        if (((!PINB.0<<3)+ (!PINB.1<<2)+ (!PINB.2<<1)+(!PINB.3))!=(j<<i) ) return 0;
       
       //PINA.3=0;PINA.4=0;PINA.5=0;PINA.6=0;  PINC.4=0;PINC.5=0;PINC.6=0;PINC.7=0; 
       PORTA &= 0x7F;
       PORTD &= 0x8F;
       PORTB &= 0xF0;
       
       delay_ms(10); 
       
        //PORTA.3=0;PORTA.4=0;PORTA.5=0;PORTA.6=0;  PORTC.4=0;PORTC.5=0;PORTC.6=0;PORTC.7=0;   
        //if (PINA.3 == 1) led = 1;
        

        //if (((PINA.3<<3)+(PINA.4<<2)+(PINA.5<<1)+(PINA.6))!=0 ) return 0;
        //if (((PINC.4<<3)+(PINC.5<<2)+(PINC.6<<1)+(PINC.7))!=0 ) return 0;
        //LOADMODEOFF;*/
         PORTA.5 = 1;
         PORTC.6 = 1;        
       }  
       //loadmodeon;
        //PORTA.3=1;PORTA.4=1;PORTA.5=1;PORTA.6=1;  PORTC.4=1;PORTC.5=1;PORTC.6=1;PORTC.7=1;
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
        //PORTA.3=0;PORTA.4=0;PORTA.5=0;PORTA.6=0;  PORTC.4=0;PORTC.5=0;PORTC.6=0;PORTC.7=0;
        
        //if (((PINA.3<<3)+(PINA.4<<2)+(PINA.5<<1)+(PINA.6))!=0) return 0;
        //if (((PINC.4<<3)+(PINC.5<<2)+(PINC.6<<1)+(PINC.7))!=0 ) return 0;
       // LOADMODEOFF; 
     }
        
      VCC = 0;
     return 1;
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

unsigned char ic74158()
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
        if (((!PINB.0<<3)+ ( !PINB.3<<2) + (!PIND.6<<1) + (!PINA.7)) != D )
        return 0;
        PORTC.5 = 1;
        delay_ms(30);
        if ((!PINB.0!=0) & (!PINB.3!=0) & (!PIND.6 !=0) & (!PINA.7!=0))
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
        if (((!PINB.0<<3)+ ( !PINB.3<<2) + (!PIND.6<<1) + (!PINA.7)) != D )
        return 0;
        PORTC.5 = 1;
        delay_ms(30);
        if ((!PINB.0!=0) && (!PINB.3!=0) && (!PIND.6 !=0) && (!PINA.7!=0))
        return 0;
        D^= 0x0F;
      }
     VCC = 0;
     return 1;
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
  DDRD = 0x80;
  PORTD &=0x0F;
  GND = 0;
  VCC2 = 1;
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
  VCC2 = 0;
 return 1;

}

