#include <mega8.h>
#include <delay.h>

const int t=1;// Time (in ms) between on/off all_out
int n;
char symb; int N1;
int Status;
int Command;
int NumPort;
int dNumPort;

char buf[6]; int i;
int m[16];

#define Y1 PORTD.3
#define Y2 PORTD.4
#define Y3 PORTB.6
#define Y4 PORTC.5
#define Y5 PORTC.4
#define Y6 PORTC.3
#define Y7 PORTC.2
#define Y8 PORTC.0
#define Y9 PORTB.2
#define Y10 PORTB.1
#define Y11 PORTB.0
#define Y12 PORTD.7
#define Y13 PORTD.6
#define Y14 PORTD.5
#define Y15 PORTB.7

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0) rx_buffer_overflow=1;
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      }
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// Write a character to the USART Transmitter
#ifndef _DEBUG_TERMINAL_IO_
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while ((UCSRA & DATA_REGISTER_EMPTY)==0);
UDR=c;
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

// Declare your global variables here
void All_OnOff()
   {
    Y1=Status; delay_ms(t);
    Y2=Status; delay_ms(t);
    Y3=Status; delay_ms(t);
    Y4=Status; delay_ms(t);
    Y5=Status; delay_ms(t);
    Y6=Status; delay_ms(t);
    Y7=Status; delay_ms(t);
    Y8=Status; delay_ms(t);
    Y9=Status; delay_ms(t);
    Y10=Status; delay_ms(t);
    Y11=Status; delay_ms(t);
    Y12=Status; delay_ms(t);
    Y13=Status; delay_ms(t);
    Y14=Status; delay_ms(t);
    Y15=Status; delay_ms(t);
   /* if (!Status)
    {
     int i=1;
     for (i=1;i<16;++i)
     {
       m[i]=0;
     }
    }*/
   }

 void Safe_OnOff()
   {
   int t=10;
   if (m[1]==1) {Y1=Status; delay_ms(t);}
   if (m[2]==1) {Y2=Status; delay_ms(t);}
   if (m[3]==1) {Y3=Status; delay_ms(t);}
   if (m[4]==1) {Y4=Status; delay_ms(t);}
   if (m[5]==1) {Y5=Status; delay_ms(t);}
   if (m[6]==1) {Y6=Status; delay_ms(t);}
   if (m[7]==1) {Y7=Status; delay_ms(t);}
   if (m[8]==1) {Y8=Status; delay_ms(t);}
   if (m[9]==1) {Y9=Status; delay_ms(t);}
   if (m[10]==1) {Y10=Status; delay_ms(t);}
   if (m[11]==1) {Y11=Status; delay_ms(t);}
   if (m[12]==1) {Y12=Status; delay_ms(t);}
   if (m[13]==1) {Y13=Status; delay_ms(t);}
   if (m[14]==1) {Y14=Status; delay_ms(t);}
   if (m[15]==1) {Y15=Status; delay_ms(t);}
   }

 void SetPort()
   {
    if (NumPort == 1) {Y1 = Status; m[1]=Status;}
    if (NumPort == 2) {Y2 = Status; m[2]=Status;}
    if (NumPort == 3) {Y3 = Status; m[3]=Status;}
    if (NumPort == 4) {Y4 = Status; m[4]=Status;}
    if (NumPort == 5) {Y5 = Status; m[5]=Status;}
    if (NumPort == 6) {Y6 = Status; m[6]=Status;}
    if (NumPort == 7) {Y7 = Status; m[7]=Status;}
    if (NumPort == 8) {Y8 = Status; m[8]=Status;}
    if (NumPort == 9) {Y9 = Status; m[9]=Status;}
    if (NumPort == 10) {Y10 = Status; m[10]=Status;}
    if (NumPort == 11) {Y11 = Status; m[11]=Status;}
    if (NumPort == 12) {Y12 = Status; m[12]=Status;}
    if (NumPort == 13) {Y13 = Status; m[13]=Status;}
    if (NumPort == 14) {Y14 = Status; m[14]=Status;}
    if (NumPort == 15) {Y15 = Status; m[15]=Status;}
   }

 void GetMPorts()
  {
   bit first=1;
     for (i=1; i<16; ++i)
     {
       if (m[i]==1)
       {
        if (!first) putchar('_');
        putchar(i+48);
        first=0;
       }
     }
     putchar(0x0D);
  }

  void GetYPorts()
  {
   bit first=1;
   int ys[16];

   if (Y1) ys[1] = 1;
   if (Y2) ys[2] = 1;
   if (Y3) ys[3] = 1;
   if (Y4) ys[4] = 1;
   if (Y5) ys[5] = 1;
   if (Y6) ys[6] = 1;
   if (Y7) ys[7] = 1;
   if (Y8) ys[8] = 1;
   if (Y9) ys[9] = 1;
   if (Y10) ys[10] = 1;
   if (Y11) ys[11] = 1;
   if (Y12) ys[12] = 1;
   if (Y13) ys[13] = 1;
   if (Y14) ys[14] = 1;
   if (Y15) ys[15] = 1;

   for (i=1; i<16; ++i)
     {
       if (ys[i]==1)
       {
        if (!first) putchar('_');
        putchar(i+48);
        first=0;
       }
     }

   putchar(0x0D);
  }

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=Out Func6=Out Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=Out
// State7=0 State6=0 State5=T State4=T State3=T State2=0 State1=0 State0=0
PORTB=0x00;
DDRB=0xC7;

// Port C initialization
// Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
// State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
PORTC=0x00;
DDRC=0x7F;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=Out Func0=Out
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=T State1=0 State0=0
PORTD=0x00;
DDRD=0xFB;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// Communication Parameters: 7 Data, 1 Stop, Even Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 38400
//UCSRA=0x00;
//UCSRB=0x98;
//UCSRC=0xA4;
//UBRRH=0x00;
//UBRRL=0x0C;
//96008N1
UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/2048k
#pragma optsize-
WDTCR=0x1F;
WDTCR=0x0F;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Global enable interrupts
#asm("sei")

while (1)
  {
       #asm("wdr")
   while (rx_counter) {   //Обрабатываем принятые данные
    symb=getchar();
    putchar(symb);
    if (n<6)
    {
     if (symb>=65 && symb<=90)
     {
      symb=symb+32;
     }
     buf[n]=symb;
    }
    ++n;
         #asm("wdr")

      if (N1==3)
      {
         if (symb=='0') { Status = 0; N1=4; }
         if (symb=='1') { Status = 1; N1=4; }
      }
      if (N1==2)
      {
         if (symb=='_') N1=3;
         else
         {
          dNumPort = symb-48;
          if (dNumPort >= 0 && dNumPort <= 9 )
          {
           NumPort = NumPort*10 + dNumPort;
           N1=3;
          }
         }
         if (N1!=3) N1=0;
      }
      if (N1==1)
      {
       if (symb=='a') { Command=1; N1=2;}
       if (symb=='s') { Command=2; N1=2;}
       if (!Command)
          {
            NumPort = symb-48;
           if (NumPort >= 0 && NumPort <= 9 ) N1=2;
           else N1=0;
          }
      }
      if (N1==0 && symb=='s') N1=1;

    if (symb==0x0D)
    {
      if (N1==4)   //Обрабатываем команды
      {
        if (Command==1) All_OnOff();
        if (Command==2) Safe_OnOff();
        if (!Command) SetPort();
      }

      if (buf[0]=='g' && buf[1]=='e' && buf[2]=='t')
      {
        if (buf[3]=='m') GetMPorts();
        if (buf[3]=='y') GetYPorts();
      }

      Command = 0;
      N1=0;
      n=0;
    }

   } //while (rx_counter) {
  } //while(1)

}