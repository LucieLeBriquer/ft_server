#!/bin/bash

BLUE='\033[1;34m'
NC='\033[0m'
CONTAINERS=$(docker ps -a | grep "ft_server" | wc -l)
CONTAINERS_ACTIVATE=$(docker ps | grep "ft_server" | wc -l)

if [[ $1 = "clean" ]]
then
	echo -e "${BLUE}> clean all unused containers and those related to ft_server${NC}"
	if [[ $CONTAINERS != "0" ]]
	then
		docker rm -f $(docker ps -a | grep "ft_server" | cut -d' ' -f1)
	fi
	docker system prune -f
	exit 1
fi

if [[ $1 = "enter" ]]
then
	if [[ $CONTAINERS_ACTIVATE != "0" ]]	
	then
		echo -e "${BLUE}> enter the container${NC}"
		docker exec -it $(docker ps -aq | head -1) bash
		exit 1
	fi
fi

echo -e "${BLUE}> build ft_server's image${NC}"
docker build --quiet -t ft_server .
if [[ $CONTAINERS != "0" ]]
then
	echo -e "${BLUE}> remove all containers related to ft_server${NC}"
	docker rm -f $(docker ps -a | grep "ft_server" | cut -d' ' -f1)
fi
echo -e "${BLUE}> create and start a container using ft_server's image${NC}"
docker run -d -p 80:80 -p 443:443 ft_server

if [[ $1 = "enter" ]]
then
	echo -e "${BLUE}> enter the container${NC}"
	docker exec -it $(docker ps -aq | head -1) bash
fi
