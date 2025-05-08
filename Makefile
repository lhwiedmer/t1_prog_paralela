CC = gcc

CFLAGS = -O3 -g -o

OMPFLAGS = -fopenmp

all: lcsSerial writeRandomIn lcsParDiag lcsParDiagBlock

noBlock: lcsSerial writeRandomIn lcsParDiag

lcsSerial:
	$(CC) $(CFLAGS) lcsSerial lcsSerial.c

lcsParDiag:
	$(CC) $(OMPFLAGS) $(CFLAGS) lcsParDiag lcsParDiag.c

lcsParDiagBlock:
	$(CC) $(OMPFLAGS) $(CFLAGS) lcsParDiagBlock lcsParDiagBlock.c

writeRandomIn:
	$(CC) $(CFLAGS) writeRandomIn writeRandomIn.c

clean:
	rm -f lcsSerial writeRandomIn lcsParDiag lcsParDiagBlock

	