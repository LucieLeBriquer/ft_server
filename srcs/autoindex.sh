#!/bin/bash

FILE="/etc/nginx/sites-available/default"

if [ $# -eq 0 ]; then
	cat $FILE | grep "autoindex" | head -1 | sed "s/\t//g" | sed "s/;//g"
	exit 1
fi

if [ $1 = "on" ]; then
	sed -i "s/autoindex off/autoindex on/g" $FILE
	service nginx reload
elif [ $1 = "off" ]; then
	sed -i "s/autoindex on/autoindex off/g" $FILE
	service nginx reload
else
	echo "use on/off parameter"
fi
