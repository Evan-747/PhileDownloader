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