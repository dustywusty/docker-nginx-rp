#!/bin/bash

cat << EOF

reverse proxy stub

EOF

# ..

set_env () {
	while [ -z "${location}" ]; do
	        read -p "location: " temp_location
	        if [ ! -z ${temp_location} ]; then
	        	location=temp_location
	        fi
	done

	while [ -z "${forwar_to}" ]; do
	        read -p "forward to" temp_forward_to
	        if [ ! -z ${temp_forward_to} ]; then
	        	forward_to=temp_forward_to
	        fi
	done

	save_env
}

# ..
build_conf () {
	# should this build conf, and then create image? or create base image, and change conf ..
}

# ..

save_env () {
	while true; do
	    read -p $'\n'"save and build docker image? y/n " yn $'\n'
	    case $yn in
	        [Yy]* ) build_image_start_container; break;;
	        [Nn]* ) exit;;
	        * ) echo "[y]es or [n]o";;
	    esac
	done
}

# ..

build_image_start_container () {
	docker.io build -t dusty/nginx-rp github.com/clarkda/docker-nginx-rp.git &&
	docker.io run -d -e ZNC_USER=${znc_user} -e ZNC_PASS=${znc_pass} -e IRC_SERVER=${irc_server} -e IRC_PORT=${irc_port} -p 6667:6667 -u znc dusty/nginx-rp
}

# ..

set_env