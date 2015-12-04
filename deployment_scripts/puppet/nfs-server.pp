notice('MODULAR: nfs-server.pp')

$nfs_plugin_data = hiera('fuel-plugin-nfs', {})
$nfs_volume_path = $nfs_plugin_data['nfs_volume_path']

if $::osfamily == 'Debian' {
  $required_pkgs = [ 'rpcbind', 'nfs-kernel-server' ]
  $services_name = 'nfs-kernel-server'

  package { $required_pkgs:
    ensure => present,
  }
  
  file { $$nfs_volume_path:
    ensure => 'directory',
    mode   => '0777',
  }
  
  file { '/etc/exports':
    content => "${nfs_volume_path} ${::network_br_storage}/255.255.255.0(rw,sync,no_subtree_check)",
  }
  
  exec { 'exportfs -ra':
    path        => ['/usr/bin', '/usr/sbin'],
    subscribe   => File['/etc/exports'],
    refreshonly => true
  }
  
  service { $services_name:
    ensure => running,
  }
}
else {
  fail("Unsuported osfamily ${::osfamily}, currently Debian are the only supported platforms")
}
