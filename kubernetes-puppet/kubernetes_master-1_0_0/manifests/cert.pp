# Puppet module to provide certs.
class kubernetes_master-1_0_0::cert {
# Create /root/kubernetes_certs to drop all certs
    file {'/root/kubernetes_certs':
        ensure  => 'directory',
        mode    => '755',
    } ->

# Create /etc/kubernetes/ssl dir for using all certs
    file {'/etc/kubernetes/ssl':
        ensure  => 'directory',
        mode    => '755',
        require => Package['kubernetes'],
    } -> 

# Copy and Change permission of all certs
    file {'/etc/kubernetes/ssl/ca-key.pem':
        source  => '/root/kubernetes_certs/ca-key.pem',
        path    => '/etc/kubernetes/ssl/ca-key.pem',
        ensure  => 'present',
        mode    => '644',
    } -> 

    file {'/etc/kubernetes/ssl/ca.pem':
        path    => '/etc/kubernetes/ssl/ca.pem',
        source  => '/root/kubernetes_certs/ca.pem',
        ensure  => 'present',
        mode    => '644',
    } ->

    file {'/etc/kubernetes/ssl/apiserver-key.pem':
        path    => '/etc/kubernetes/ssl/apiserver-key.pem',
        source  => '/root/kubernetes_certs/apiserver-key.pem',
        ensure  => 'present',
        mode    => '644',
    } ->

    file {'/etc/kubernetes/ssl/apiserver.pem':
        path    => '/etc/kubernetes/ssl/apiserver.pem',
        source  => '/root/kubernetes_certs/apiserver.pem',
        ensure  => 'present',
        mode    => '644',
    } ->

# Create /usr/share/ca-certificates dir for  System CA certs on centos 7
    file {'/usr/share/ca-certificates':
        ensure  => 'directory',
        mode    => '755',
    } ->

# copy and change permissions of certs
    file {'/usr/share/ca-certificates/tls-ca-bundle.pem':
        source  => '/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem',
        path    => '/usr/share/ca-certificates/tls-ca-bundle.pem',
        ensure  => 'present',
        mode    => '644',
    } ->

# copy and change permissions of certs
    file {'/usr/share/ca-certificates/ca-bundle.trust.crt':
        source  => '/etc/pki/ca-trust/extracted/openssl/ca-bundle.trust.crt',
        path    => '/usr/share/ca-certificates/ca-bundle.trust.crt',
        ensure  => 'present',
        mode    => '644',
    }
}
