source ./localvars.conf

set -euo pipefail

log() {
	echo "$(date "+%F %T") | $1" >> "$logfile"
}

check_log() {
	journalctl -u ${services[@]} --since "5 minutes ago" | \
		grep -iE "$pattern" > /dev/null
}

can_restart() {
	if [[ -f "$state" ]] ; then
		last="$(cat "$state")"
		now="$(date +%s)"
		diff=$(( now - last  ))
	
		if [[ $diff -lt $cooldown ]] ; then
			log "Cooldown is Active, Skipping restart"
			return 1
		fi
	fi
	return 0
}

recover_service() {
	if systemctl is-active ${services[@]} --quiet ; then
		log "Restarting "${services[@]}" due to detected issue"
		systemctl restart ${services[@]}
		date +%s > "$state"
	else log ""${services[@]}" already down, Attempting start"
		systemctl start ${services[@]}
		date +%s > "$state"
	fi
}

main() {
	log "----- Checking "${services[@]}" logs -----"
	if check_log ; then
		log "Failure pattern detected in logs"
	    if can_restart ; then
		recover_service
	    fi
       else log "no issue detected"
	fi
}

main
