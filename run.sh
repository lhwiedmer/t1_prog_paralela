#!/bin/bash

make
echo 'Código compilado'

echo "tam|threads|block|diff_avg|diff_std|elapsed_avg|elapsed_std|miss_avg" > avg_results.txt


for tam in 20000 40000 60000 80000 100000; do
    ./writeRandomIn fileA.in $tam
    echo "Arquivo A criado tamanho=$tam"

    sleep 3

    ./writeRandomIn fileB.in $tam
    echo "Arquivo B criado tamanho=$tam"

    results_file="results_${tam}.txt"


    # SERIAL: 20 runs, capture perf output
    for k in $(seq 1 20); do
        perf stat -e cache-references,cache-misses -- ./lcsSerial >> "$results_file" 2>&1
    done



            # Extract lcsTime and time elapsed
    grep 'lcsTime:' "$results_file" | awk -F':' '{gsub(",", ".", $2); print $2}' > lcs_times.txt
    grep "seconds time elapsed" "$results_file" | awk '{gsub(",", ".", $1); print $1}' > elapsed_times.txt

    cat lcs_times.txt
    echo "----------------"
    cat elapsed_times.txt
    echo "----------------"

            # Compute difference lcsTime - elapsed
    paste elapsed_times.txt lcs_times.txt | LC_ALL=C awk '{printf "%.9f\n", $1 - $2}' > time_diffs.txt
            #paste lcs_clean.txt elapsed_clean.txt | awk '{print $2 - $1}' > time_diffs.txt


    cat time_diffs.txt

    # Average and stddev of ΔTime
    read diff_avg diff_std < <(
        LC_ALL=C awk '{
            sum += $1; sumsq += $1*$1; n++
        }
        END {
            if (n > 0) {
                mean = sum / n
                stddev = sqrt((sumsq / n) - (mean * mean))
                printf "%.3f %.3f", mean, stddev
            }
        }' time_diffs.txt
    )

    # Average and stddev of elapsed time
    read elapsed_avg elapsed_std < <(
        LC_ALL=C awk '{
            sum += $1; sumsq += $1*$1; n++
        }
        END {
            if (n > 0) {
                mean = sum / n
                stddev = sqrt((sumsq / n) - (mean * mean))
                printf "%.2f %.3f", mean, stddev
            }
        }' elapsed_times.txt
    )


    # Append to avg_results.txt with placeholders for thread and block as 0
    echo "$tam|-|-|$diff_avg|$diff_std|$elapsed_avg|$elapsed_std|-" >> avg_results.txt

    rm -f serial_miss_rates.txt


    # PARALLEL runs
    # for block in 1024; do
    #     for threads in 1 2 4 8 12; do
    #         echo "Executando paralelo com $threads threads e $block blockTam"

    #         results_file="parallel_results_${tam}.txt"
    #         rm -f "$results_file"

    #         for k in $(seq 1 20); do
    #             perf stat -e cache-references,cache-misses -- ./lcsParDiagBlock $threads $block >> "$results_file" 2>&1
    #         done


    #         # Extract lcsTime and time elapsed
    #         grep 'lcsTime:' "$results_file" | awk -F':' '{gsub(",", ".", $2); print $2}' > lcs_times.txt
    #         grep "seconds time elapsed" "$results_file" | awk '{gsub(",", ".", $1); print $1}' > elapsed_times.txt

    #         wc -l lcs_times.txt elapsed_times.txt

    #         # Compute difference lcsTime - elapsed
    #         paste elapsed_times.txt lcs_times.txt | LC_ALL=C awk '{printf "%.9f\n", $1 - $2}' > time_diffs.txt
    #         #paste lcs_clean.txt elapsed_clean.txt | awk '{print $2 - $1}' > time_diffs.txt

    #         cat time_diffs.txt

    #         # Average and stddev of ΔTime
    #         read diff_avg diff_std < <(
    #             LC_ALL=C awk '{
    #                 sum += $1; sumsq += $1*$1; n++
    #             }
    #             END {
    #                 if (n > 0) {
    #                     mean = sum / n
    #                     stddev = sqrt((sumsq / n) - (mean * mean))
    #                     printf "%.3f %.3f", mean, stddev
    #                 }
    #             }' time_diffs.txt
    #         )

    #         # Average and stddev of elapsed time
    #         read elapsed_avg elapsed_std < <(
    #             LC_ALL=C awk '{
    #                 sum += $1; sumsq += $1*$1; n++
    #             }
    #             END {
    #                 if (n > 0) {
    #                     mean = sum / n
    #                     stddev = sqrt((sumsq / n) - (mean * mean))
    #                     printf "%.2f %.3f", mean, stddev
    #                 }
    #             }' elapsed_times.txt
    #         )

    #         # Extract and average cache miss rates
    #         grep "cache-misses" "$results_file" | tail -n 20 | awk -F'#' '{gsub(",", ".", $2); print $2}' | awk '{print $1}' > tmp_miss_rates.txt
    #         read miss_avg < <(
    #             awk '{sum += $1} END {if (NR > 0) printf "%.6f", sum / NR}' tmp_miss_rates.txt
    #         )

    #         echo "ΔTime Média=$diff_avg s | ΔTime Std=$diff_std s | Elapsed Média=$elapsed_avg s | Elapsed Std=$elapsed_std s"

    #         echo "$tam|$threads|$block|$diff_avg|$diff_std|$elapsed_avg|$elapsed_std|$miss_avg" >> avg_results.txt

    #         rm -f lcs_times.txt elapsed_times.txt time_diffs.txt tmp_miss_rates.txt "$results_file"
    #     done
    # done

done

make clean

