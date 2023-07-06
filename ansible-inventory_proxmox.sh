nodes="$(ssh root@$PVE "cat /etc/pve/.members | jq -r '.nodelist[] | select(.online == 1) | .ip'")"
echo "[proxmox_nodes]\n$nodes" > ansible-inventory_proxmox.ini
