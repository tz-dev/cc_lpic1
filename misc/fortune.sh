#! /bin/bash
clear													# clear screen

(fortune -s > _fortune.txt)								# give wisdom & store in file
sentence=$(<_fortune.txt)								# store content in variable

let i=0													# index variable
let j=0													# helper variable
let pitch=50											# voice pitch
let chars=0												# variable for word character count
let content=0											# variable for word content
let column=0											# variable for cursor positioning
let line=0												# variable for cursor positioning
let width=$(tput cols)-30								# variable for console width & delimiting text

for word in $sentence									# write words of sentence in single files
do
	echo $word > _fortune0$i
	i=$[i+1]
done

while [ $i -gt 0 ]
do
	chars=$(wc -m < _fortune0$j)						# count characters in word for pause timing
	content=$(<_fortune0$j)
	column=$[column+chars]								# increment column for cursor positioning

	if [[ $content == *"--"* ]]; then					# if end of citation is reached, lower voice pitch
  		pitch=$[pitch-25]
	fi

	(cat _fortune0$j | espeak -a 75 -p $pitch -s 150 &)	# speak single word in background
	cat _fortune0$j | pv -qL 15							# type word when spoken

	if [ $column -gt $width ]; then						# switch to next line if max width is reached
		column=0
		line=$[line+1]
	fi

	tput cup $line $column								# position cursor before typing next word in sentence

	if [ $chars -gt 10 ]								# longer pause if more than 9 characters occur in a single word
	then
		espeak -s 100 ...
	else
		espeak -s 100 ..
	fi

	i=$[i-1]
	j=$[j+1]
done

rm _fortune*											# remove obsolete files
echo													# print blank line