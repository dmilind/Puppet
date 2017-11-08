# Puppet file to configure kubernetes cluster master nodes.
class kubernetes_master-1_0_0::local_config {
# Copy etcd.conf file
  file {'etcd.conf':
      path    => '/etc/etcd/etcd.conf',
      ensure  => 'present',
      content => template("$module_name/etcd.conf.erb"),
      mode    => '644',
      require => Package['etcd'],
  } -> 

# Copy flannel conf file 
  file {'flanneld':
      path    => '/etc/sysconfig/flanneld',
      ensure  => 'present',
      content => template("$module_name/flanneld.erb"),
      mode    => '644',
      require => Package['flannel'],
  } ->

# Copy etcd change user scipt
  file {'/etc/kubernetes/switchUser.sh':
      ensure  => 'present',
      source  => "puppet:///modules/$module_name/switchUser.sh",
      path    => '/etc/kubernetes/switchUser.sh',
      owner   => 'root',
      group   => 'root',
      mode    => '755',
  } 

# Execute switchUser.sh to reload daemon on changes in etcd.service
 exec {'switchUser.sh':
      command  => "/bin/bash -c '/etc/kubernetes/switchUser.sh'",
      unless   => "/bin/grep -q 'User=root' /usr/lib/systemd/system/etcd.service", 
      require  => File['/etc/kubernetes/switchUser.sh'],
  } ->

# Starting etcd
  service {'etcd':
      name    => 'etcd',
      ensure  => 'running',
      enable  => 'true',
      require => Package['etcd'],
  } ->

# setting etcd for flanneld network local to single host
  exec {'/usr/bin/etcdctl':
      command => "/usr/bin/etcdctl --endpoints=https://$kubernetes01:2379,https://$kubernetes02:2379,https://$kubernetes03:2379 --ca-file=/etc/kubernetes/ssl/ca.pem --cert-file=/etc/kubernetes/ssl/apiserver.pem --key-file=/etc/kubernetes/ssl/apiserver-key.pem set /kube-centos/network/config '{\"Network\":\"172.10.0.0/16\", \"Backend\": {\"Type\": \"vxlan\"}}' > /root/etcd.ran",
      creates => '/root/etcd.ran',
      require => Package['etcd'],
  } -> 

# Start flanneld service
  service {'flanneld':
      name    => 'flanneld',
      ensure  => 'running',
      require => Package['flannel'],
  } -> 

# Wait for flanneld to come up
  
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
  } 

}



