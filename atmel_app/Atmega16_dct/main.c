/*
* Atmega16_dct.c
*
* Created: 19-Oct-17 10:37:36
* Author : yahor.halubchyk
*/
#define F_CPU 8000000UL

#include <avr/io.h>
#include <stdio.h>
#include <stdlib.h>

#define LCD_TYPE 1
#define LCD_SIZE_XY 20,4

#define LCD_IO_RS C, 6
#define LCD_IO_RW C, 7
#define LCD_IO_E  A, 7
#define LCD_IO_D4 A, 6
#define LCD_IO_D5 A, 5
#define LCD_IO_D6 A, 4
#define LCD_IO_D7 A, 3

char lcd_buffer[10];
#include <lcd/lcd.h>

//****************** temperature
#define SENS_DS18B20_NUM 3
int16_t ds18b20_t[SENS_DS18B20_NUM];
uint8_t ds18b20_rom_codes[SENS_DS18B20_NUM][8]={
	// {0x28,0xFD,0xD9,0xFC,0x4,0x00,0x00,0x76,0x01},
	{0x28,0xFF,0xDA,0xFC,0x04,0x00,0x00,0x56},
	{0x28,0x4D,0xE7,0xA9,0x04,0x00,0x00,0x0E},
	{0x28,0xF0,0xB1,0xA9,0x04,0x00,0x00,0x4A},
};

#define SENS_DS18B20_IO B, 2
#include <sensors/ds18b20.h>
const uint8_t Ts_X[SENS_DS18B20_NUM] = {10, 9, 20};
const uint8_t Ts_Y[SENS_DS18B20_NUM] = {1, 3, 3};

//#define but1 PIND.6
//#define but2 PIND.5
//#define but3 PIND.3
//#define but4 PIND.2

#define IO_LedLcd A, 2
#define IO_PowerSupply B, 4
portValue_s portVal;

//**************** clock
#define SENS_DS1307_IO_SCL B, 0
#define SENS_DS1307_IO_SDA B, 1
#include <sensors/ds1307.h>
time_s rtcTime = { dayWeek: 1};
bool m_day;

//***************** DHT22
#define SENS_DHT22_IO B, 3
#include <sensors/dht22.h>
const uint8_t  TRoom_Y = 2;
const uint8_t  TRoom_X = 10;
const uint8_t  HumRoom_Y = 2;
const uint8_t  HumRoom_X = 17;
int16_t dht22_hum;
int16_t dht22_t;

//***************** soft uart
#define USOFT_BAUD 4800
#define USOFT_BUFFER_EN false
//#define USOFT_AUTOLISTEN true	 //todo implement autolisten
//#define USOFT_TXEN false
#define USOFT_IO_RX C, 1
#define USOFT_IO_TX C, 0
#include <uart_soft.h>

//***************** hard uart
#define UHARD_BAUD 4800
#define UHARD_BUFFER_EN false
#include <uart_hard.h>

//***************** techBrain
#include <uart_techBrain.h>

bool goNewDay;
void clocky (void) {
	if (sens_ds1307_getTime(&rtcTime))
	{
		if (goNewDay && rtcTime.hour == 0)
		{
			++rtcTime.dayWeek;
			if (rtcTime.dayWeek > 7)
			rtcTime.dayWeek = 1;
			goNewDay = false;

		}
		if (!goNewDay && rtcTime.hour == 23)
		{
			goNewDay = true;
		}
		lcd_goto_xy(1,0); lcd_putChar(rtcTime.dayWeek%10+0x30);
		lcd_goto_xy(10,0);
		lcd_putChar(rtcTime.hour/10+0x30);lcd_putChar(rtcTime.hour%10+0x30); lcd_putChar(':');
		lcd_putChar(rtcTime.min/10+0x30); lcd_putChar(rtcTime.min%10+0x30); lcd_putChar(':');
		lcd_putChar(rtcTime.sec/10+0x30); lcd_putChar(rtcTime.sec%10+0x30);
	}
}

unsigned char get_x(char *str, unsigned char startX)
{
	uint8_t countChar = 0;
	while (*str)
	{
		++countChar;
		++str;
	}
	return startX - countChar;
}

void checkCmd()
{
	utb_getCmd();
}

uint8_t bt;
int main(void)
{
	io_set(DDR, IO_LedLcd);
	io_setPort(IO_LedLcd);

	sens_ds1307_init();

	//time_s t = {11,25,0};
	//sens_ds1307_setTime(t);
	
	if (lcd_init())
	{
		lcd_goto_xy(2,0);  lcd_putStringf("day");
		//Outdoor
		lcd_goto_xy(0,1);  lcd_putStringf("Ul");
		//Room
		lcd_goto_xy(0,2); lcd_putStringf("Kom");
		lcd_goto_xy(14,2); lcd_putStringf("RH=");
		//Balcony
		lcd_goto_xy(0,3); lcd_putStringf("Bln");
		//Cellar
		lcd_goto_xy(11,3); lcd_putStringf("Pgb");
	}
	
	usoft_init();
	uhard_init();

	static int16_t	*sens[5];
	sens[0] = ds18b20_t;
	sens[1] = ds18b20_t + 1;
	sens[2] = ds18b20_t + 2;
	sens[3] = &dht22_t;
	sens[4] = &dht22_hum;
	utb_init2(&rtcTime, &portVal, sens, 5);

	uint8_t count = 0;
	
	while (1)
	{
		clocky();

		/*******************************************************************
		led light
		********************************************************************/
		if (rtcTime.hour >= 22 || rtcTime.hour < 9)
		{
			io_resetPort(IO_LedLcd);
		}
		else
		{
			io_setPort(IO_LedLcd);
		}

		if (count == 0 || count > 20)//period for long-time requests
		{
			count = 0;
			/*******************************************************************
			humidity
			********************************************************************/
			if (sens_dht22_read(&dht22_hum, &dht22_t))
			{
				//Humidity
				sprintf(lcd_buffer,"%d%%",dht22_hum / 10); //DHT22
				lcd_goto_xy(HumRoom_X,HumRoom_Y); lcd_putStringf("   ");
				lcd_goto_xy(HumRoom_X,HumRoom_Y); lcd_putString((unsigned char *)lcd_buffer); //lcd_putChar('%');
				
				//Temperature
				sprintf(lcd_buffer,"%d.%d",dht22_t / 10, dht22_t % 10); //DHT22
				lcd_goto_xy(TRoom_X - 5, TRoom_Y); lcd_putStringf("     ");
				lcd_goto_xy(get_x(lcd_buffer,TRoom_X),TRoom_Y); lcd_putString((unsigned char *)lcd_buffer);
			}
			/*******************************************************************
			temperature
			********************************************************************/
			if (sens_ds1820_readByRom(ds18b20_t, ds18b20_rom_codes))
			{
				for (uint8_t i = 0; i < SENS_DS18B20_NUM; ++i)
				{
					char sign = (ds18b20_t[i] < 0) ? '-' : ' ';
					sprintf(lcd_buffer, "%c%d.%d",sign, abs(ds18b20_t[i])/10, abs(ds18b20_t[i]) % 10);
					lcd_goto_xy(Ts_X[i] - 5,Ts_Y[i]); lcd_putStringf("    ");
					lcd_goto_xy(get_x(lcd_buffer, Ts_X[i]), Ts_Y[i]); lcd_putString((unsigned char *)lcd_buffer);
				}
			}
		}
		else
		{
			delay_ms(100);
		}

		checkCmd();
		++count;
	}
}

USOFT_ISR_newByte(b)
{
	utb_byteReceived(b);
}

UTB_UART_SEND(str, num)
{
	usoft_putBytes(str, num);
}

UHARD_ISR_newByte(b)
{
	//utb_byteReceived(b);
}
