#!/bin/bash

make
echo 'Código compilado'

echo "Tamaho da Entrada|N. Threads|Tamanho do Bloco|Tempo Médio|Desvio Padrão|Taxa de Cache-Miss Média|" > avg_results.txt


for tam in 20000 40000 60000 80000 100000; do
    ./writeRandomIn fileA.in $tam
    echo "Arquivo A criado tamanho=$tam"

    sleep 3

    ./writeRandomIn fileB.in $tam
    echo "Arquivo B criado tamanho=$tam"

    # SERIAL: 20 runs, capture perf output
    rm -f serial_results.txt
    for k in $(seq 1 20); do
        echo "Executando serial com teste de cache $k vez"
        perf stat -e cache-references,cache-misses -o serial_results.txt --append -- ./lcsSerial
    done

    # Extract "time elapsed" for serial and compute average
    grep "seconds time elapsed" serial_results.txt | awk '{print $1}' > serial_times.txt


    # Extract cache miss rates for serial
    grep "cache-misses" serial_results.txt | tail -n 20 | awk -F'#' '{gsub(",", ".", $2); print $2}' | awk '{print $1}' > serial_miss_rates.txt

    # Compute averages for serial run
    read serial_miss_avg < <(
        awk '{sum += $1} END {if (NR > 0) printf "%.6f", sum / NR}' serial_miss_rates.txt
    )

    read serial_avg serial_std < <(
        awk '{
            sum += $1; sumsq += $1 * $1; n++
        }
        END {
            if (n > 0) {
                mean = sum / n
                stddev = sqrt((sumsq / n) - (mean * mean))
                printf "%.6f %.6f", mean, stddev
            }
        }' serial_times.txt
    )

    echo "Média serial para tamanho=$tam: $serial_avg segundos"
    echo "Desvio padrão serial: $serial_std segundos"

    # Append to avg_results.txt with placeholders for thread and block as 0
    echo "$tam|-|-|$serial_avg|$serial_std|$serial_miss_avg" >> avg_results.txt

    rm -f serial_miss_rates.txt


    # PARALLEL runs
    for block in 1024; do
        for threads in 2 4 8 12; do
            echo "Executando paralelo com $threads threads e $block blockTam"

            results_file="parallel_results_${tam}.txt"
            rm -f "$results_file"

            for k in $(seq 1 20); do
                perf stat -e cache-references,cache-misses -o "$results_file" --append -- ./lcsParDiagBlock $threads $block
            done

            grep "seconds time elapsed" "$results_file" | tail -n 20 | awk '{print $1}' > tmp_times.txt

            # Extract cache miss rates (as decimals, e.g., 0.8427)
            grep "cache-misses" "$results_file" | tail -n 20 | awk -F'#' '{gsub(",", ".", $2); print $2}' | awk '{print $1}' > tmp_miss_rates.txt

            # Compute average miss rate
            read miss_avg < <(
            awk '{sum += $1} END {if (NR > 0) print sum / NR}' tmp_miss_rates.txt
            )

            read avg std < <(
            awk '{
                sum += $1; sumsq += $1 * $1; n++
            }
            END {
                if (n > 0) {
                    mean = sum / n
                    stddev = sqrt((sumsq / n) - (mean * mean))
                    print mean, stddev
                }
            }' tmp_times.txt
            )

            echo "Média para $threads threads e $block blockTam: $avg segundos"
            echo "Desvio padrão: $std segundos"

            echo "$tam|$threads|$block|$avg|$std|$miss_avg" >> avg_results.txt

            rm -f tmp_miss_rates.txt serial_times.txt serial_results.txt
            rm -f tmp_times.txt
        done
    done
done

make clean


