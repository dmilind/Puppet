# Puppet file to configure kubernetes cluster on agent nodes.
class kubernetes_agent-1_0_0::kube_config {
  file { '/etc/kubernetes/kube_config.yaml':
      path    => '/etc/kubernetes/kube_config.yaml',
      ensure  => 'present',
      content => template("$module_name/kube_config.yaml.erb"),
      mode    => '644',
  } ->

  file { '/etc/sysconfig/flanneld':
      path    => '/etc/sysconfig/flanneld',
      ensure  => 'present',
      content => template("$module_name/flanneld.erb"),
      mode    => '644',
      require => Package['flannel'],
  } -> 

  file {'kubelet':
      path    => '/etc/kubernetes/kubelet',
      ensure  => 'present',
      content => template("$module_name/kubelet.erb"),
      mode    => '644',
  } ->

  file {'haproxy.cfg':
      path    => '/etc/kubernetes/haproxy.cfg',
      ensure  => 'present',
      content => template("$module_name/haproxy.cfg.erb"),
      mode    => '644',
  } ->

  file {'/etc/kubernetes/manifests':
      ensure  => 'directory',
      mode    => '755',
  } ->

  file { '/etc/kubernetes/manifests/kube_proxy.yaml':
      path    => '/etc/kubernetes/manifests/kube_proxy.yaml',
      ensure  => 'present',
      content => template("$module_name/kube_proxy.yaml.erb"),
      mode    => '644',
  } ->

  file { '/etc/kubernetes/manifests/haproxy.yaml':
      path    => '/etc/kubernetes/manifests/haproxy.yaml',
      ensure  => 'present',
      content => template("$module_name/haproxy.yaml.erb"),
      mode    => '644',
  } ->

  exec { '/usr/bin/etcdctl':
      command => "/usr/bin/etcdctl --endpoints=https://$kubernetes01:2379,https://$kubernetes02:2379,https://$kubernetes03:2379 --ca-file=/etc/kubernetes/ssl/ca.pem --cert-file=/etc/kubernetes/ssl/apiserver.pem --key-file=/etc/kubernetes/ssl/apiserver-key.pem get /kube-centos/network/config > /root/etcd.ran",
      creates => '/root/etcd.ran',
      require => Package['etcd'],
  } ->
      
  service {'flanneld':
      name    => 'flanneld',
      ensure  => 'running',
      require => Package['flannel'],
  }  

# Wait for flannel to come up

# Copy checkdocker.sh script
  file {'/etc/kubernetes/checkdocker.sh':
      ensure  => 'present',
      source  => "puppet:///modules/$module_name/checkdocker.sh",
      path    => '/etc/kubernetes/checkdocker.sh',
      owner   => 'root',
      group   => 'root',
      mode    => '755',
      notify  => Exec['checkdocker.sh'],
  }

# Execute checkdocker.sh
  exec {'checkdocker.sh':
      command  => "/bin/bash -c '/etc/kubernetes/checkdocker.sh'",
      require  => File['/etc/kubernetes/checkdocker.sh'],
      creates  => '/root/checkdocker.ran',
  } ->

# Starting kubelet service
  service {'kubelet':
      name    => 'kubelet',
      ensure  => 'running',
      require => Package['kubernetes'],
  }
}
