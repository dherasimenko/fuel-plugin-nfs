class nfs::env_verification {

    if $::osfamily == 'Debian' {
        $required_pkgs = [ 'rpcbind', 'nfs-kernel-server' ]
        $services_name = 'nfs-kernel-server'
        $nfs_srv_folder = '/nfs'
    }
    else {
        fail("unsuported osfamily ${::osfamily}, currently Debian are the only supported platforms")
    }
}

class nfs::server {

    include nfs::env_verification
    
    package { $nfs::env_verification::required_pkgs:
       ensure => present,
    }

    file { $nfs::env_verification::nfs_srv_folder:
       ensure => 'directory',
       mode => '0777',
    }

    file { '/etc/exports':
       content => "$nfs::env_verification::nfs_srv_folder $::network_br_storage/255.255.255.0(rw,sync,no_subtree_check)",
    }

exec { 'exportfs -ra':
    path => ["/usr/bin", "/usr/sbin"],
    subscribe => File["/etc/exports"],
    refreshonly => true
}
    
    service { $nfs::env_verification::services_name:
       ensure => running,
    }
}

include nfs::server
