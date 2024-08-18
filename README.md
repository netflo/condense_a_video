# condense_a_video

#this shell script takes an input video (example: input-lession1.mp4) and extracts the time ranges defined in the second argument file (times-lession1) and outputs the result into an output mp4 (lesson1-condensed.mp4)

./shrink_vid6.sh input-lesson1.mp4 times-lesson1 lesson1-condensed.mp4



times-lesson1 lists the section to keep in the following hr:min:sec format with 1 entry per line:

00:51:54 00:55:42
00:56:10 01:04:20
01:06:50 01:08:08


