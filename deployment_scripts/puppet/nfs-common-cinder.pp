notice('MODULAR: nfs-common-cinder.pp')

$nodes = hiera('nodes', {})
$nfs_plugin_data = hiera('fuel-plugin-cinder-nfs', {})
$cinder_nfs_share = '/etc/cinder/nfs_shares.txt'

# set path to folder where nfs will be mouned on cinder server
$nfs_mount_point = $nfs_plugin_data['nfs_mount_point']

# set path to nfs folder on nfs server
$nfs_volume_path = $nfs_plugin_data['nfs_volume_path']

# get storage IP of NFS Servers, mount storaget on Compute node
define nfs_server_ip {
  if $name['role'] == 'nfs-server' {
    file { $cinder_nfs_share:
      ensure => present,
      owner  => 'cinder',
      group  => 'cinder',
    }->
    file_line { 'nfs_line':
      line => "${name['storage_address']}:${nfs_volume_path}",
      path => $cinder_nfs_share
    }
  }
}

if $::osfamily == 'Debian' {
  $required_pkgs = [ 'cinder-volume', 'nfs-common' ]
  $service_name = 'cinder-volume'

  file { $nfs_mount_point:
    ensure => 'directory',
    mode   => '0755',
    owner  => 'cinder',
    group  => 'cinder',
  }

  # cinder config changes here 
  # puppetlab openstack/cinder module installation required
  cinder_config {
    'DEFAULT/volume_driver' :
      value => 'cinder.volume.drivers.nfs.NfsDriver';
    'DEFAULT/nfs_shares_config' :
      value => $cinder_nfs_share;
    'DEFAULT/nfs_sparsed_volumes' :
      value => 'True';
    'DEFAULT/nfs_oversub_ratio' :
      value => '1.0';
    'DEFAULT/nfs_used_ratio' :
      value => '0.95';
    'DEFAULT/nfs_mount_attempts' :
      value => '3';
    'DEFAULT/nfs_mount_point_base' :
      value => $nfs_mount_point;
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
