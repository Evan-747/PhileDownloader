#!/bin/bash
##################################
#Copyright (c) 2014 Sam-Hentschel#
##################################

#Function to display the usage of the command
function usage()
{
    printf "    phrackdownloader -d downloads_file_path -f main_folder_name [-h] [-i] -m newest_issue_of_phrack -t target_file_path [-v]\n"
    printf "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n"
    printf "    d downloads_file_path -/- sets the path to your downloads folder (required if -i, or -h is not activated)\n"
    printf "    f main_folder_name -/- sets the name of the main folder (if not set, default is \"Philes\")\n"
    printf "    h -/- prints the help usage page (aka, this one)\n"
    printf "    i -/- turns on interactive mode (creates a dialogue)\n"
    printf "    m -/- tells the program which issue to download until (should be set to the newest)\n"
    printf "    t target_file_path -/- sets the path to your target folder (required if -i, or -h is not activated)\n"
    printf '    v -/- sets verbose mode on\n'
}

#Function to take the input data and deliver the folders to the users
function maker()
{
    mkdir ${target}/${folder}
    for i in $(seq $min $max)
    do
        name=$i
        mkdir ${target}/${folder}/${i}
        echo '...Downloading File...'
        cd ${down}
        curl -O http://www.phrack.org/archives/tgz/phrack${name}.tar.gz
        echo '-----Download Complete-----'
        downloads_g=${down}/phrack${name}.tar.gz
        echo '...Ungunzipping file...'
        gunzip $downloads_g
        echo '-----Finished Ungunning the file-----'
        downloads_t=${down}/phrack${name}.tar
        echo '...Untarring file...'
        tar -xzvf $downloads_t -C ${target}/${folder}/${i}
        echo '-----Finished Untarring the file-----'
        echo '...Deleting original files...'
        rm $downloads_t
        echo '-----Original Files Deleted-----'
    done
}

#Function to initiate interactive mode of input
function interactive()
{
    echo 'What is the newest issue of Phrack? '
    read max
    echo 'What is the file path to your downloads folder?'
    read down
    echo 'What is the file path to your destination folder?'
    read target
    echo 'What would you like the folder name for the storage of the issues to be?'
    read folder
    maker
}

#Starts to check the options and start the respective next function (interactive or maker)
while getopts ":d:f:him:t:v" arg
do
    case $arg in
        d)
            down=${OPTARG}
            ;;
        f)
            folder=${OPTARG}
            ;;
        h)
            usage
            exit
            ;;
        i)
            interact=1
            break
            ;;
        m)
            max=${OPTARG}
            ;;
        t)
            target=${OPTARG}
            ;;
        v)
            echo "verbose"
            ;;
        *)
            usage
            exit
            ;;
    esac
done
if [ "$interact" == "1" ]
then
    interactive
else
    maker
fi