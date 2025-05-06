CC = gcc

CFLAGS = -g

all: lcsSerial writeRandomIn

lcsSerial:
	$(CC) $(CFLAGS) -o lcsSerial lcsSerial.c

writeRandomIn:
	$(CC) $(CFLAGS) -o writeRandomIn writeRandomIn.c

clean:
	rm -f lcsSerial writeRandomIn