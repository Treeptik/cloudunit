#!/bin/sh
# get docker container names
# launch registry: 2 on and listen to port: 5000

echo ">>> Installing registry:2"
docker run -d -p 5000:5000 --name registry registry:2

echo ">>> Analyse all CloudUnit images"
# get all docker images name
NAME=$(docker images | grep cloudunit | awk 'BEGIN { OFS = ":" }{ print $1, $2 }')
printf "$NAME"
echo ""

clairctl version
# launch clairctl push, pull, analyze, report to html to the registry:2 with debug mode 
# to hide debug mode, remove --log-level debug 
for arg in $NAME ; do
	sudo clairctl push -l $arg --log-level debug; 
	sudo clairctl pull -l $arg    
	echo ""
	sudo clairctl analyze -l $arg;   
	echo ""
	sudo clairctl report -l $arg;   
	echo "***********************"
done

# remove registry
echo ">>> Removing local docker registry:2"
docker rm -f registry:2

exit 1