import os
import csv
import numpy as np
import sys

def calculate_avg_and_std(results_dir):
    # Create a list to store the final results
    final_results = []

    # Walk through the results directory and process each CSV file
    for filename in os.listdir(results_dir):
        if filename.endswith(".csv"):
            file_path = os.path.join(results_dir, filename)

            # Extract thread and input size from the filename
            parts = filename.replace('.csv', '').split('_')
            thread_count = int(parts[1])
            input_size = int(parts[3])

            # Read the CSV file and store the values
            parallel_times = []
            total_times = []
            serial_times = []

            with open(file_path, 'r') as csvfile:
                reader = csv.reader(csvfile)
                next(reader)  # Skip header row
                for row in reader:
                    parallel_times.append(float(row[0]))
                    total_times.append(float(row[1]))
                    serial_times.append(float(row[2]))

            # Calculate the average and standard deviation for parallel, total, and serial times
            avg_parallel_time = np.mean(parallel_times)
            std_parallel_time = np.std(parallel_times)

            avg_total_time = np.mean(total_times)
            std_total_time = np.std(total_times)

            avg_serial_time = np.mean(serial_times)
            std_serial_time = np.std(serial_times)

            # Append the results in the final list
            final_results.append({
                "input_size": input_size,
                "threads": thread_count,
                "avg_parallel_time": avg_parallel_time,
                "std_parallel_time": std_parallel_time,
                "avg_total_time": avg_total_time,
                "std_total_time": std_total_time,
                "avg_serial_time": avg_serial_time,
                "std_serial_time": std_serial_time
            })

    # Write the results to a new CSV file
    output_csv = os.path.join(results_dir, "summary_results.csv")
    with open(output_csv, 'w', newline='') as csvfile:
        fieldnames = [
            "input_size", "threads", "avg_parallel_time", "std_parallel_time",
            "avg_total_time", "std_total_time", "avg_serial_time", "std_serial_time"
        ]
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for result in final_results:
            writer.writerow(result)

    print(f"Results saved to {output_csv}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 calculate_avg_and_std.py <results_directory>")
        sys.exit(1)

    results_dir = sys.argv[1]
    if not os.path.exists(results_dir):
        print(f"Error: Directory {results_dir} does not exist.")
        sys.exit(1)

    calculate_avg_and_std(results_dir)
