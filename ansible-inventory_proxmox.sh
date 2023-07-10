#
#		OVERVIEW:
#
#		A shell script that generates a static ansible inventory file
#		containing a list of available nodes in a proxmox cluster.
#
#		PREREQUISITES:
#
#		Ideally, you should have key-based password-less SSH login setup. Even
#		more ideal that you have a low-power node like a thin client as part
#		of your PVE cluster that is trivial to keep powered on with a UPS.
#
#		$PVE is an environment variable pointing to the ip address or hostname
#		of that low-power node. It should be defined in your .zshrc or .bashrc
#		file like so:
#
#		export PVE=192.168.254.1
#
#		jq should be installed/present on that proxmox node.
#
#		STRATEGY:
#
#		Parse the JSON formatted file at /etc/pve/.members and strip it down
#		to just the IP addresses of nodes that are currently online and then
#		generate a static ini-style inventory file for ansible to use under
#		the host group named proxmox_nodes
#
#
nodes="$(ssh root@$PVE "cat /etc/pve/.members | jq -r '.nodelist[] | select(.online == 1) | .ip'")"
echo "[proxmox_nodes]\n$nodes" > $(dirname "$0")/ansible-inventory_proxmox.ini
#
#
#		EXTENDING:
#
#		Setup aliases in your shell to run the script inline with ansible,
#		also in your .zshrc or .bashrc file:
#
#		alias ans="ansible-inventory_proxmox.sh && ansible -i ansible-inventory_proxmox.ini"
#		alias ani="ansible-inventory_proxmox.sh && ansible-inventory -i ansible-inventory_proxmox.ini"
#
