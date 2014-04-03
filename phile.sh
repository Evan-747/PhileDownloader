#!/bin/bash
##################################
#Copyright (c) 2014 Sam-Hentschel#
##################################
folder="Philes"
#Function to display the usage of the command
function usage()
{
    printf "    philedownloader -d downloads_file_path -f main_folder_name [-h] [-i] -t target_file_path [-v] option1 [...]\n"
    printf "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n"
    printf "    d downloads_file_path -/- sets the path to your downloads folder (required if -i, or -h is not activated)\n"
    printf "    f main_folder_name -/- sets the name of the main folder (if not set, default is \"Philes\")\n"
    printf "    h -/- prints the help usage page (aka, this one)\n"
    printf "    i -/- turns on interactive mode (creates a dialogue)\n"
    printf "    t target_file_path -/- sets the path to your target folder (required if -i, or -h is not activated)\n"
    printf '    v -/- sets verbose mode on\n'
    printf "    option1 ... -/- the options to be downloaded to the user's local directory"
}

#Function to take the input data and deliver the phrack issues to the users
function phrack()
{
    mkdir ${target}/${folder}
    for i in $(seq 1 $max)
    do
        name=$i
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
}

#Function to take the input data and deliver the rfc issues to the user
function rfc()
{
    echo "rfc"
}

#Function to initiate interactive mode of input
function interactive()
{
    echo 'What is the file path to your downloads folder?'
    read down
    echo 'What is the file path to your destination folder?'
    read target
    echo 'What would you like the folder name for the storage of the issues to be?'
    read folder
    if [ "$folder" == "" ]
    then
        folder=Philes
    fi
    echo "What files would you like to download? (type phrack, or rfc) [type next to continue]"
    while :
    do
        read option
        if [ "$option" == "phrack" ]
        then
            phrack_files=true
        elif [ "$option" == "rfc" ]
        then
            rfc_files=true
        elif [ "$option" == "next" ]
        then
            break
        else
            echo "Invalid option, try again."
        fi
    done
    if [ "$phrack_files" == "true" ]
    then
        echo 'What is the newest issue of Phrack? '
        read max
        phrack
    elif [ "$rfc_files" == "true" ]
    then
        rfc
    else
        echo "Would you like to quit? (Y/n)"
        read ans
        if [ "$ans" == "Y" ]
        then
            exit
        else
            interactive
        fi
    fi
}

#Starts to check the options and start the respective next function (interactive or maker)
while :
do
    case $1 in
        (-h | --help | -\?)
            usage
            exit
            ;;
        (-i | --interact)
            interact=1
            break
            ;;
        (-d | --download)
            down=$2
            shift 2
            ;;
        (-f | --folder)
            shift
            folder=$1
            shift 
            ;;
        (-t | --target)
            target=$2
            shift 2
            ;;
        (-v | --verbose)
            echo "verbose"
            exit
            ;;
        (--)
            shift
            break
            ;;
        (-*)
            echo "invalid option"
            shift
            ;;
        (*)
            break
            ;;
    esac
done
if [ "$interact" == "1" ]
then
    interactive
elif [ ! "$target" ]
then
    echo "Target directory not specified"
    usage
    exit
elif [ ! "$down" ]
then
    echo "Downloads directory not specified"
    usage
    exit
elif [ ! "$1" ]
then
    echo "No options specified"
    usage
    exit
else
    while [ "$1" != "" ]
    do
        option=$1
        if [ "$option" == "phrack" ]
        then
            phrack_files=true
            shift
        elif [ "$option" == "rfc" ]
        then
            rfc_files=true
            shift
        else
            echo "Invalid options passed"
        fi
    done
fi
if [ "$phrack_files" == "true" ]
then
    echo "What's the newest issue of Phrack?"
    read max
    phrack
fi
if [ "$rfc_files" == "true" ]
then
    rfc
fi
