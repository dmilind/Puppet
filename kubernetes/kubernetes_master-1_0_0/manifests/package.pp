# Puppet module to install packages

class kubernetes_master-1_0_0::package {
# Install Flannel package
    package { 'flannel':
        name    => 'flannel',
        ensure  => '0.7.0-1.el7',
    } ->

# Install etcd package
    package {'etcd':
        name    => 'etcd',
        ensure  => '3.1.7-1.el7',
    } ->

# Install kubernetes package
    package {'kubernetes':
        name    => 'kubernetes',
        ensure  => '1.5.2-0.2.gitc55cf2b.el7',
#        require => Yumrepo['kubernetes'],
    } ->

# disable firewalld service on host
    service {'firewalld':
        name    => 'firewalld',
        ensure  => 'stopped',
        enable  => 'false',
    } 
}

