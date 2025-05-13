CC = gcc

CFLAGS = -O3 -g -o

OMPFLAGS = -fopenmp

all: lcsSerial writeRandomIn lcsParDiag lcsParDiagBlock

noBlock: lcsSerial writeRandomIn lcsParDiag

lcsSerial: lcsSerial.c
	$(CC) $(OMPFLAGS) $(CFLAGS) lcsSerial lcsSerial.c

lcsParDiag: lcsParDiag.c
	$(CC) $(OMPFLAGS) $(CFLAGS) lcsParDiag lcsParDiag.c

lcsParDiagBlock: lcsParDiagBlock.c
	$(CC) $(OMPFLAGS) $(CFLAGS) lcsParDiagBlock lcsParDiagBlock.c

writeRandomIn: writeRandomIn.c
	$(CC) $(CFLAGS) writeRandomIn writeRandomIn.c

clean:
	rm -f lcsSerial writeRandomIn lcsParDiag lcsParDiagBlock

	