CC = gcc

CFLAGS = -g -o

OMPFLAGS = -fopenmp

all: lcsSerial writeRandomIn

lcsSerial:
	$(CC) $(CFLAGS) lcsSerial lcsSerial.c

lcsParalelo:
	$(CC) $(CFLAGS) $(OMPFLAGS) lcsParalelo lcsParalelo.c

writeRandomIn:
	$(CC) $(CFLAGS) writeRandomIn writeRandomIn.c

clean:
	rm -f lcsSerial writeRandomIn lcsParalelo