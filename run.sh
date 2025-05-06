#!/bin/bash

make

echo 'Código compilado'

./writeRandomIn fileA.in

echo 'Arquivo A criado'

./writeRandomIn fileB.in

echo 'Arquivo B criado'

time ./lcsSerial

make clean