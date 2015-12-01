notice('MODULAR: nfs-common.pp')

# get storage IP of NFS Servers, mount storaget on Compute node
define nfs_server_ip {
  if $name['role'] == 'nfs-server' {
    mount { '/mnt/nfs':
      ensure  => mounted,
      atboot  => true,
      device  => "${name['storage_address']}:/nfs",
      fstype  => 'nfs',
      options => 'vers=4',
    }
  }
}

if $::osfamily == 'Debian' {
  $required_pkgs = [ 'rpcbind', 'nfs-common' ]
  $service_name = 'rpcbind'
  
  package { $required_pkgs:
    ensure => present,
  }
  
  service { $service_name:
    ensure => running,
  }

  $nodes = hiera('nodes')
  nfs_server_ip { $nodes: }

}
else {
  fail("Unsuported osfamily ${::osfamily}, currently Debian are the only supported platforms")
}
