#!/bin/bash

input_file="$1"
times_file="$2"
output_file="$3"

# Temporary file to list the segments
concat_list="concat_list.txt"
> "$concat_list" # Clear the file

while read start stop; do
    # Remove any potential leading/trailing spaces
    start=$(echo $start | xargs)
    stop=$(echo $stop | xargs)

    # Ensure correct time format (e.g., 00:01:00)
    if [[ ! $start =~ ^[0-9]{2}:[0-9]{2}:[0-9]{2}(\.[0-9]{1,3})?$ ]]; then
        echo "Invalid start time format: $start"
        continue
    fi

    if [[ ! $stop =~ ^[0-9]{2}:[0-9]{2}:[0-9]{2}(\.[0-9]{1,3})?$ ]]; then
        echo "Invalid stop time format: $stop"
        continue
    fi

    # Calculate the duration between start and stop
    start_seconds=$(echo "$start" | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
    stop_seconds=$(echo "$stop" | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
    duration=$(echo "$stop_seconds - $start_seconds" | bc)

    # Output filename based on start and stop times
    segment_output="output_${start//:/-}_${stop//:/-}.mp4"

    # Run ffmpeg with -ss before -i and use -t for duration
    ffmpeg -ss "$start" -i "$input_file" -t "$duration" -c copy "$segment_output" &1>/dev/null

    # Add the segment to the concat list
    echo "file '$segment_output'" >> "$concat_list"

done < "$times_file"

# Concatenate all segments into the final output file
ffmpeg -f concat -safe 0 -i "$concat_list" -c copy "$output_file" &1>/dev/null

# Clean up temporary files
#rm "$concat_list"

echo "All segments have been concatenated into $output_file."

