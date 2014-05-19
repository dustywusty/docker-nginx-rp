#!/bin/bash

cat << EOF
           _                           
 _ _  __ _(_)_ _ __ __  ___   _ _ _ __ 
| ' \/ _\` | | ' \\\ \ / |___| | '_| '_ \\
|_||_\__, |_|_||_/_\_\       |_| | .__/
     |___/                       |_| 

EOF

# ..

set_env () {
	location=''
	proxy_pass=''

	while [ -z "${location}" ]; do
	        read -p "location: " temp_location
	        if [ ! -z ${temp_location} ]; then
	        	location=${temp_location}
	        fi
	done

	while [ -z "${proxy_pass}" ]; do
	        read -p "proxy pass: " temp_proxy_pass
	        if [ ! -z ${temp_proxy_pass} ]; then
	        	proxy_pass=${temp_proxy_pass}
	        fi
	done

	build_conf
}

# ..

build_conf () {
	conf="$(awk -v var="\n\t\tlocation /${location} {\n\t\t\tproxy_pass ${proxy_pass};\n\t\t\tproxy_redirect off;\n\t\t\tproxy_set_header Host \$host;\n\t\t\tproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;\n\t\t}\n" '
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
	local conf_dir=/var/docker/nginx-rp/etc/nginx/sites-enabled

	mkdir -p ${conf_dir} &&
	mv conf/nginx.conf ${conf_dir} &&
	docker.io build -t dusty/nginx-rp github.com/clarkda/docker-nginx-rp.git &&
	docker.io run -d -p 80:80 dusty/nginx-rp
}

# ..

set_env