# Puppet module to provide certs.

class kubernetes_pupa::cert {

# Create /etc/kubernetes/ssl dir for using all certs
    file {'/etc/kubernetes/ssl':
        ensure  => 'directory',
        mode    => '755',
    } -> 

# Copy and Change permission of all certs
    file {'/etc/kubernetes/ssl/ca-key.pem':
        source  => '/root/kubernetes_certs/ca-key.pem',
        path    => '/etc/kubernetes/ssl/ca-key.pem',
        ensure  => 'present',
        mode    => '644',
    } 

    file {'/etc/kubernetes/ssl/ca.pem':
        path    => '/etc/kubernetes/ssl/ca.pem',
        source  => '/root/kubernetes_certs/ca.pem',
        mode    => '644',
    } 

    file {'/etc/kubernetes/ssl/apiserver-key.pem':
        path    => '/etc/kubernetes/ssl/apiserver-key.pem',
        source  => '/root/kubernetes_certs/apiserver-key.pem',
        mode    => '644',
    } 

    file {'/etc/kubernetes/ssl/apiserver.pem':
        path    => '/etc/kubernetes/ssl/apiserver.pem',
        source  => '/root/kubernetes_certs/apiserver.pem',
        mode    => '644',
    } 

}
