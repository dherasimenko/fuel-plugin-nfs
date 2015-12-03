notice('MODULAR: nfs-common.pp')

$nodes = hiera('nodes', {})
$nfs_plugin_data = hiera('fuel-plugin-nfs', {})
$nfs_mount_point = $nfs_plugin_data['nfs_mount_point']
$nfs_volume_path = $nfs_plugin_data['nfs_volume_path']

# get storage IP of NFS Servers, mount storaget on Compute node
define nfs_server_ip {
  if $name['role'] == 'nfs-server' {
    mount { $nfs_mount_point:
      ensure  => mounted,
      atboot  => true,
      device  => "${name['storage_address']}:${nfs_volume_path}",
      fstype  => 'nfs',
      options => 'vers=4',
    }
  }
}

if $::osfamily == 'Debian' {
  $required_pkgs = [ 'rpcbind', 'nfs-common' ]
  $service_name = 'rpcbind'

  file { $nfs_mount_point:
    ensure => 'directory',
    mode   => '0777',
  }
  
  package { $required_pkgs:
    ensure => present,
  }
  
  service { $service_name:
    ensure => running,
  }

  nfs_server_ip { $nodes: }

}
else {
  fail("Unsuported osfamily ${::osfamily}, currently Debian are the only supported platforms")
}
