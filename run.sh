#!/bin/bash

make

echo 'Código compilado'

./writeRandomIn fileA.in

echo 'Arquivo A criado'

./writeRandomIn fileB.in

echo 'Arquivo B criado'

echo 'Executando serial'

time ./lcsSerial

echo 'Executando paralelo'

time ./lcsParalelo

make clean