class nfs {

    if $::osfamily == 'Debian' {
        package { 'nfs-common' :
            ensure => 'installed',
        }
    } 
    else {
        fail("unsuported osfamily ${::osfamily}, currently Debian are the only supported platforms")
    }
}
