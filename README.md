# Collection of useful Ansible roles and configurations

This is a sanitized version of the Ansible configurations / roles / playbooks I use internally at home. It contains many things I use all the time, and some things I'm still developing.

Of interest:

* DHCP / DNS configuration (CentOS only), in the directory role
* Raspberry Pi install playbooks
* OctoPrint / Klipper install via respective roles
* Libvirt VM setup role (vm-install, CentOS only)
* NFS client/server setups, with option for encrypted LVM volume (3 roles, CentOS only)
* Netmeter (my python application to log network stats to a Graphite DB server, via MQTT or local port)

There isn't a lot of documentation, but with some determination and knowledge of Ansible it should be relatively clear what the parts do.
