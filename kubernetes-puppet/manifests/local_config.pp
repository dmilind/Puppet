# Puppet file to configure kubernetes cluster on master and agent nodes.
class kubernetes_pupa::local_config {
# Copy etcd.conf file
  file {'etcd.conf':
      path    => '/etc/etcd/etcd.conf',
      ensure  => 'present',
      content => template("$module_name/etcd.conf.erb"),
      mode    => '644',
  } -> 

# Copy flannel conf file 
  file {'flanneld':
      path    => '/etc/sysconfig/flanneld',
      ensure  => 'present',
      content => template("$module_name/flanneld.erb"),
      mode    => '644',
  } ->

# Starting etcd
  service {'etcd':
      name    => 'etcd',
      ensure  => 'running',
      enable  => 'true',
  } ->

# setting etcd for flanneld network local to single host
  exec {'/usr/bin/etcdctl':
      command => "/usr/bin/sleep 10 && /usr/bin/etcdctl --endpoints=https://$master01_IP:2379,https://$master02_IP:2379 --ca-file=/etc/kubernetes/ssl/ca.pem --cert-file=/etc/kubernetes/ssl/apiserver.pem --key-file=/etc/kubernetes/ssl/apiserver-key.pem set /kube-centos/network/config '{\"Network\":\"172.10.0.0/16\", \"Backend\": {\"Type\": \"vxlan\"}}'",
  } -> 

# Start flanneld service
  service {'flanneld':
      name    => 'flanneld',
      ensure  => 'running',
      require => Package['flannel'],
  } -> 

# Wait for flanneld to come up
  exec {'sleep 120':
      command => '/usr/bin/sleep 30',
  } -> 

# Starting docker
  service {'docker':
      name    => 'docker',
      ensure  => 'running',
      enable  => 'true',
  }
}



