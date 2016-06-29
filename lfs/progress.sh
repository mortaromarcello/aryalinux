function print_progress_bar()
{
	echo -ne "["
	for i in $(seq 1 $1)
	do
		echo -ne "="
	done
	for i in $(seq $1 99)
	do
		echo -ne " "
	done
	echo -ne "] $1% \r"
}

function show_file_progress()
{
	LEN="0"
	PER=0
	while [ $PER -le 100 ]
	do
		print_progress_bar $PER
		if [ "$1" != "`cat /sources/file2track`" ]
		then
			return
		fi
		sleep 0.5
		LEN=`wc -l /sources/logs/$1 | cut -d ' ' -f1`
		PER=`echo - | awk "{print int($LEN/$2 * 100)}"`
	done
}

#sleep 5
while true
do
	if [ ! -f /sources/file2track ]
	then
		break
	fi
	FILE=`cat /sources/file2track`
	MAX=`cat /sources/lines2track`

	echo "Now running : `echo $FILE | sed 's@\.log@\.sh@g'`"
	echo "Start time: `date`"
	SECONDS=0
	show_file_progress $FILE $MAX
	echo ""
	echo "End time: `date`"
	echo "Total run time : $(($SECONDS / 60)) mins and $(($SECONDS % 60)) secs"
	echo ""
	sleep 0.5
done
