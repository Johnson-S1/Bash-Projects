#!/bin/bash

set -euo pipefail

#name="$1"
#groupname=("support" "developers")
#ssh_key="$2"


log() {
    echo "$(date "+%F %T") | $1"
}

can_create() {

	if id "$name" &>/dev/null ; then
		log "Username $name Already Exists"
	else
		useradd -m "$name"
		log "Username $name Successfully Created"
	fi
}

assign_group() {
	for group in "${groupname[@]}" ; do
		if ! getent group "$group" > /dev/null ; then 
			groupadd "$group" 
			log "Group "$group" create"
		fi
		usermod -aG "$group" "$name"
		log "Added "$name" to "$group" group"
	done
}

setup_acl() {
	setfacl -m u:"$name":rwx /tmp
	log "ACL set for $name on /tmp"
}

setupssh() {
	local dir=/home/"$name"/.ssh/
		mkdir -p "$dir"
		echo "$ssh_key" > "$dir/authorized_keys"
		chown -R "$name":"$name" "$dir"
		chmod 700 "$dir"
		chmod 600 "$dir/authorized_keys"
		log "SSH key deployed for $name"
	
}

main() {
       if [[ "$#" -lt 2 ]] ; then
	       log "$0 <username> <ssh-public-key>"
	       exit 1
       fi
       name="$1"
       groupname=("support" "developers")
       ssh_key="$2"
       log "Starting user lifecycle setup for $name" 
       can_create
       assign_group
       setup_acl
       setupssh
       log "User lifecycle setup completed"
}

main "$@"

    
