#!/bin/bash
set -euo pipefail

source ./threshold.conf
log() {
echo "$(date "+%F %T") | $1" >> "$LOGFILE"
}
evaluate() {
local name=$1
local value=$2
local crit=$3
local warn=$4
if [[ $value -gt $crit ]] ; then
	log "$name CRITICAL: $value%"
elif [[ $value -gt $warn ]] ; then
        log "$name WARNING: $value%"
else 
	log "$name is HEALTHY: $value%"
fi
}

check_cpu() {
  local cpu
  cpu="$(awk '/^cpu / {usage=($2+$4)/($2+$4+$5)*100;print int(usage)}' /proc/stat)"
  evaluate "CPU" "$cpu" "$CPU_CRIT" "$CPU_WARN"
}

check_mem() {
	local mem
	mem="$(free  | awk '/Mem:/ {mem=$3/$2*100; print int(mem)}')"
	evaluate "Mem" "$mem" "$MEM_CRIT" "$MEM_WARN"
}

check_disk() {
	local disk
	df -h | awk 'NR>1&&NR<3 {print $5,$6}' | while read usage mount; do
	blocks="${usage%\%}"
	evaluate "filesystem $mount" "$blocks" "$DISK_CRIT" "$DISK_WARN"
        done
}

check_services() {
	for serv in "${services[@]}"; do
  	systemctl is-active --quiet "$serv"
	if [[ "$?" -eq 0 ]]; then
		log "$serv: Service Ok"
	else log "Service Critical: $serv"
	fi
        done
}

main() {
log "############ Health Check Started ############"
    check_cpu
    check_mem
    check_disk
    check_services
log "############ Health Check Completed ############"
} 
main
