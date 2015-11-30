    if $::osfamily == 'Debian' {
      $required_pkgs = [ 'rpcbind', 'nfs-kernel-server' ]
      $services_name = 'nfs-kernel-server'
      $nfs_srv_folder = '/nfs'

      package { $required_pkgs:
        ensure => present,
      }

      file { $nfs_srv_folder:
        ensure => 'directory',
        mode   => '0777',
      }

      file { '/etc/exports':
        content => "${nfs_srv_folder} ${::network_br_storage}/255.255.255.0 (rw,sync,no_subtree_check)",
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
