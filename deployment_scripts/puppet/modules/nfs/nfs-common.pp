class nfs::env_verification {

    if $::osfamily == 'Debian' {
        $required_pkgs = [ 'rpcbind', 'nfs-common' ]
        $service_name = 'rpcbind'
    }
    else {
        fail("unsuported osfamily ${::osfamily}, currently Debian are the only supported platforms")
    }
}

class nfs::common {

    include nfs::env_verification
    
    package { $nfs::env_verification::required_pkgs:
       ensure => present,
    }
    
    service { $nfs::env_verification::service_name:
       ensure => running,
    }
}

include nfs::common
