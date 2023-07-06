#
#		OVERVIEW:
#
#		A shell script that generates a static inventory file which can be
#		used by ansible containing a list of nodes in a proxmox cluster.
#
#		PREREQUISITES:
#
#		Ideally, you should have key-based password-less SSH login setup. Even
#		more ideal that you have a low-power node like a thin client as part
#		of your PVE cluster that is trivial to keep powered on with a UPS.
#
#		JQ should be installed/present on the proxmox node.
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
echo "[proxmox_nodes]\n$nodes" > ansible-inventory_proxmox.ini
#
#
#		EXTENDING:
#
#		Setup aliases in your shell to run the script inline with ansible:
#
#		alias ans="ansible-inventory_proxmox.sh && ansible -i ansible-inventory_proxmox.ini"
#		alias ani="ansible-inventory_proxmox.sh && ansible-inventory -i ansible-inventory_proxmox.ini"
#
