#!/bin/bash

BLUE='\033[1;34m'
NC='\033[0m'
CONTAINERS=$(docker ps -aq | wc -l)
CONTAINERS_ACTIVATE=$(docker ps -q | wc -l)
CURRENT=$(docker ps -q | head -1)

if [[ $1 = "clean" ]]
then
	echo -e "${BLUE}> remove all containers${NC}"
	if [[ $CONTAINERS != "0" ]]
	then
		docker rm -f $(docker ps -aq)
	fi
	docker system prune -f
	exit 1
fi

if [[ $1 = "enter" ]]
then
	if [[ $CONTAINERS_ACTIVATE != "0" ]]	
	then
		echo -e "${BLUE}> enter the container${NC}"
		docker exec -it $CURRENT bash
		exit 1
	fi
fi

if [[ $1 = "autoindex" ]]
then
	if [[ $CONTAINERS_ACTIVATE != "0" ]]	
	then
		echo -e "${BLUE}> switch autoindex on/off${NC}"
		OPTION=$(docker exec -it $CURRENT bash ./autoindex.sh | grep "off" | wc -l)
		if [[ $OPTION = "0" ]]
		then
			echo -e "deactivate autoindex"
			docker exec -it $CURRENT bash ./autoindex.sh off
		else
			echo -e "activate autoindex"
			docker exec -it $CURRENT bash ./autoindex.sh on
		fi
		exit 1
	fi
fi

echo -e "${BLUE}> build ft_server's image${NC}"
docker build --quiet -t ft_server .
if [[ $CONTAINERS != "0" ]]
then
	echo -e "${BLUE}> remove all containers${NC}"
	docker rm -f $(docker ps -aq)
fi
echo -e "${BLUE}> create and start a container using ft_server's image${NC}"
docker run -d -p 80:80 -p 443:443 ft_server

if [[ $1 = "enter" ]]
then
	echo -e "${BLUE}> enter the container${NC}"
	docker exec -it $(docker ps -aq | head -1) bash
fi
