#!/bin/bash
#
#Copyright (c) 2014 Sam-Hentschel
#
#####MAKE SURE TO PUT THIS FILE IN YOUR DOWNLOADS FOLDER!!!!!!
#
#
echo 'What is the newest issue of Phrack? '
read max
echo 'Do you have any issues of Phrack already? '
read answer
if [ $answer == 'Yes' ]
then
	echo 'What is the last one you have?'
	read min
	min=$((min+1))
else
	min=1
fi
echo 'What is the file path to your downloads folder?'
read down
echo 'What is the file path to your destination folder?'
read target
echo 'What would you like the folder name for the storage of the issues to be?'
read folder
mkdir ${target}/${folder}
for i in $(seq $min $max)
do
	name=$i
	echo '...Downloading File...'
	curl -O http://www.phrack.org/archives/tgz/phrack${name}.tar.gz
	echo '-----Download Complete-----'
	downloads_g=${down}/phrack${name}.tar.gz
	echo '...Ungunzipping file...'
	gunzip $downloads_g
	echo '-----Finished Ungunning the file-----'
	downloads_t=${down}/phrack${name}.tar
	echo '...Untarring file...'
	tar -xzvf $downloads_t
	echo '-----Finished Untarring the file-----'
        download=${down}/${name}
	echo '...Moving file...'
	endpath=${target}/${folder}
	mv $download $endpath
	echo '-----Moved file-----'
	echo '...Checking and fixing extension...'
	for f in ${endpath}/${name}
	do
		if [ ${f: -4} != '.txt' ]
			then
				find $f -type f -not -name "*.*" -exec mv "{}" "{}".txt \;
		fi
	done
	echo '-----Extensions correct-----'
	echo '...Deleting original files...'
	rm $downloads_t
	echo '-----Original Files Deleted-----'
done
echo 'Phrack archive of issues complete...you are now the proud owner of all issues of Phrack'