    if $::osfamily == 'Debian' {
      $required_pkgs = [ 'rpcbind', 'nfs-common' ]
      $service_name = 'rpcbind'

      package { $required_pkgs:
        ensure => present,
      }
    
      service { $service_name:
        ensure => running,
      }
    }
    else {
      fail("Unsuported osfamily ${::osfamily}, 
           currently Debian are the only supported platforms")
    }

    

