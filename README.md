
### overview

A shell script that generates a static ansible inventory file containing a list of available nodes in a proxmox cluster.

---

### prerequisites

Ideally, you should have key-based password-less SSH login setup. Even more ideal that you have a low-power node like a thin client as part of your PVE cluster that is trivial to keep powered on with a UPS.

jq should be installed/present on the proxmox node.

---

### strategy

Parse the JSON formatted file at /etc/pve/.members and strip it down to just the IP addresses of nodes that are currently online and then generate a static ini-style inventory file for ansible to use under
the host group named proxmox_nodes

---

### code

    nodes="$(ssh root@$PVE "cat /etc/pve/.members | jq -r '.nodelist[] | select(.online == 1) | .ip'")"
    echo "[proxmox_nodes]\n$nodes" > ansible-inventory_proxmox.ini

---

### extending

Setup aliases in your shell to run the script inline with ansible:

    alias ans="ansible-inventory_proxmox.sh && ansible -i ansible-inventory_proxmox.ini"
    alias ani="ansible-inventory_proxmox.sh && ansible-inventory -i ansible-inventory_proxmox.ini"
