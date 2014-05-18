#!/bin/bash

cat << EOF

reverse proxy stub

EOF

# ..

set_env () {
	location=''
	forward_to=''

	while [ -z "${location}" ]; do
	        read -p "location: " temp_location
	        if [ ! -z ${temp_location} ]; then
	        	location=${temp_location}
	        fi
	done

	while [ -z "${forward_to}" ]; do
	        read -p "forward to: " temp_forward_to
	        if [ ! -z ${temp_forward_to} ]; then
	        	forward_to=${temp_forward_to}
	        fi
	done

	build_conf
}

# ..

build_conf () {
	conf="$(awk -v var="\n\t\tlocation /${location} {\n\t\t\tproxy_pass ${forward_to};\n\t\t\tproxy_redirect off;\n\t\t\tproxy_set_header Host \$host;\n\t\t\tproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;\n\t\t}\n" '
	/# {{begin}}/{f=1}
	f {print;print var;f=0;next}
	1' conf/nginx.conf)"

	echo "${conf}" > conf/nginx.conf

	while true; do
	    read -p "add another proxy config? y/n " yn
	    case $yn in
	        [Yy]* ) set_env; break;;
	        [Nn]* ) save_env;;
	        * ) echo "[y]es or [n]o";;
	    esac
	done
}

# ..

save_env () {
	while true; do
	    read -p "save and build docker image? y/n " yn
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