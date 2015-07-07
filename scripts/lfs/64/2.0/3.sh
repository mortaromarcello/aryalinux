. inputs
for script in testsuite-tools/*
do
	$script
done

for script in final-system/*
do
	$script
done

echo "Now execute 4.sh by entering the following below:"
echo "./4.sh"
