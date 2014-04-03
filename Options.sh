while getopts ":d:f:hit:v" arg
do
    case $arg in
        d)
            down=${OPTARG}
            ;;
        f)
            folder=${OPTARG}
            ;;
        h)
            echo "usage"
            ;;
        i)
            interactive=1
            ;;
        o)
            if [ "${OPTARG}" == "Phrack" ]
            then
                phrack=true
            elif [ "${OPTARG}" == "RFCs" ]
            then
                rfc=true
            elif [ "${OPTARG}" == "Java Books" ]
            then
                java=true
            else
                echo "Not a valid option"
            fi
            ;;
        t)
            target=${OPTARG}
            ;;
        v)
            echo "verbose"
            ;;
        *)
            echo "usage"
            ;;
    esac
done
echo $down
echo $folder
echo $target
echo $interactive
echo done
echo $phrack
echo $rfc
echo $java