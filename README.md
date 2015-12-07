NFS Server Plugin for Cinder
============

Compatible versions:
- Mirantis Fuel 7.0

Abilities: 
- Setup NFS Server Service on separate bare metal
- Reconfigure Cinder for work with NFS Service as a Storage.

How to Build and Install:
- git clone git@github.com:dherasimenko/fuel-plugin-nfs.git
- fpb --build ./fuel-plugin-nfs
- fuel plugins --install fuel-plugin-cinder-nfs-1.0-1.0.0-1.noarch.rpm

READY FOR QA:
- firewall setup and configuration
- eliminate hardcode in https://github.com/dherasimenko/fuel-plugin-nfs/blob/v1.0.0/deployment_scripts/puppet/nfs-server.pp#L19-L21
  cidr /24 - hardcode
- delete https://github.com/dherasimenko/fuel-plugin-nfs/blob/v1.0.0/deployment_tasks.yaml#L13 for version with Cinder
- https://github.com/dherasimenko/fuel-plugin-nfs/blob/v1.0.0/deployment_scripts/puppet/nfs-server.pp#L19
  а сюда не плохо бы вставить notify на сервис тогда этот экзек не нужен https://github.com/dherasimenko/fuel-plugin-nfs/blob/v1.0.0/deployment_scripts/puppet/nfs-server.pp#L23-L27
