#!/bin/bash
##################################
#Copyright (c) 2014 Sam-Hentschel#
##################################
folder="RFCs"
#Function to display the usage of the command
function usage()
{
    printf "    rfcdownloader -d downloads_file_path -f main_folder_name [-h] [-i] [-p] -t target_file_path [-v]\n"
    printf "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n"
    printf "    d downloads_file_path -/- sets the path to your downloads folder (required if -i, or -h is not activated)\n"
    printf "    f main_folder_name -/- sets the name of the main folder (if not set, default is \"Philes\")\n"
    printf "    h -/- prints the help usage page (aka, this one)\n"
    printf "    i -/- turns on interactive mode (creates a dialogue)\n"
    printf "    p -/- downloads the files in pdf format"
    printf "    t target_file_path -/- sets the path to your target folder (required if -i, or -h is not activated)\n"
    printf "    v -/- sets verbose mode on\n"
}

#Function to take the input data and deliver the folders to the users
function maker()
{
    mkdir ${target}/${folder}
    mkdir ${target}/${folder}/RFCs
    echo '...Downloading File...'
    echo 'This may take a while.'
    cd ${down}
    curl -O ftp://ftp.rfc-editor.org/in-notes/tar/RFC-all.tar.gz
    echo '-----Download Complete-----'
    downloads_g=${down}/RFC-all.tar.gz
    echo '...Ungunzipping file...'
    gunzip $downloads_g
    echo '-----Finished Ungunning the file-----'
    downloads_t=${down}/RFC-all.tar
    echo '...Untarring file...'
    tar -xzvf $downloads_t -C ${target}/${folder}/RFCs
    echo '-----Finished Untarring the file-----'
    echo '...Deleting original files...'
    rm $downloads_t
    echo '-----Original Files Deleted-----'
}

function maker()
{
    mkdir ${target}/${folder}
    mkdir ${target}/${folder}/RFCs
    echo '...Downloading File...'
    echo 'This may take a while.'
    cd ${down}
    curl -O ftp://ftp.rfc-editor.org/in-notes/tar/pdfrfc-all.tar.gz
    echo '-----Download Complete-----'
    downloads_g=${down}/pdfrfc-all.tar.gz
    echo '...Ungunzipping file...'
    gunzip $downloads_g
    echo '-----Finished Ungunning the file-----'
    downloads_t=${down}/pdfrfc-all.tar
    echo '...Untarring file...'
    tar -xzvf $downloads_t -C ${target}/${folder}/RFCs
    echo '-----Finished Untarring the file-----'
    echo '...Deleting original files...'
    rm $downloads_t
    echo '-----Original Files Deleted-----'
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
    echo 'Would you like it in pdf or txt format? (type the one you would like)'
    read ans
    if [ "$ans" == "pdf" ]
    then
        pdfmaker
    else
        maker
    fi
}

#Starts to check the options and start the respective next function (interactive or maker)
while :
do
    case $1 in
        (-h | --help)
            usage
            exit
            ;;
        (-i | --interactive)
            interact=1
            break
            ;;
        (-d | --download)
            down=$2
            shift 2
            ;;
        (-f | --folder)
            folder=$2
            shift 2
            ;;
        (-p | --pdf)
            pdf=1
            ;;
        (-t | --target)
            target=$2
            shift 2
            ;;
        (-v | --verbose)
            echo "verbose"
            ;;
        (--)
            shift
            break
            ;;
        (-*)
            echo "invalid option"
            shift
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
elif [ "$pdf" == "1" ]
then
    pdfmaker
else
    maker
fi