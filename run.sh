make
echo 'Código compilado'

./writeRandomIn fileA.in 90000
echo "Arquivo A criado tamanho=90000"

sleep 3

./writeRandomIn fileB.in 90000
echo "Arquivo B criado tamanho=90000"

echo "Executando serial com teste de cache"
perf stat -e cache-references,cache-misses ./lcsSerial

./lcsParDiagBlock 12
