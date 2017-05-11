# Puppet module to install packages

class kubernetes_pupa::package {
# Install Flannel package
    package { 'flannel':
        name    => 'flannel',
        ensure  => 'latest',
    } ->

# Install etcd package
    package {'etcd':
        name    => 'etcd',
        ensure  => 'latest',
    } ->

# Install kubernetes package
    package {'kubernetes':
        name    => 'kubernetes',
        ensure  => 'latest',
    } ->

# disable firewalld service on host
    service {'firewalld':
        name    => 'firewalld',
        ensure  => 'stopped',
        enable  => 'false',
    } 
}

