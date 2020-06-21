#! /bin/bash
clear													# clear screen
let sentence=$(fortune -s)								# store fortune in variable
let chars=0												# variable for word character count
let column=0											# variable for cursor column positioning
let line=0												# variable for cursor line positioning
let width=$(tput cols)-30								# variable for console width & delimiting text
let pitch=50											# voice pitch default
for word in $sentence									# process each word of sentence
do
	chars=${#word}										# get length of word
	column=$[column+chars+1]							# increment column for cursor positioning
	if [ $column -gt $width ]; then						# jump to beginning of next line if max width is reached
		column=0
		line=$[line+1]
	fi
	if [[ $word == *"--"* ]]; then						# if end of citation is reached, lower voice pitch
  		pitch=$[pitch-25]
	fi
	(espeak -a 75 -p $pitch -s 150 $word&)				# speak word in background
	echo $word | pv -qL 15								# print word with typewriter effect
	espeak .. -s500										# insert pause between words
	tput cup $line $column								# position cursor before typing next word in sentence
done
echo													# print blank line