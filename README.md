NFS Server/Client Plugin
============

Compatible versions:
- Mirantis Fuel 7.0

Abilities: 
- Setup NFS Server Service on separate bare metal
- Setup NFS Client on all Compute Servers.
- Auto mount NFS Storage to all Compute Servers
  according to plugin settings from Fuel UI

How to Build and Install:
- git clone git@github.com:dherasimenko/fuel-plugin-nfs.git
- fpb --build ./fuel-plugin-nfs
- fuel plugins --install fuel-plugin-nfs-1.0-1.0.0-1.noarch.rpm
