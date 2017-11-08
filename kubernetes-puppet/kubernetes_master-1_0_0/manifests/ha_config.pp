# Puppet file to configure kubernetes master on kubernetes hosts.
class kubernetes_master-1_0_0::ha_config {
# Copy kubelet and kube_conf to /etc/kubernetes dir
  file {'kubelet':
      path    => '/etc/kubernetes/kubelet',
      ensure  => 'present',
      content => template("$module_name/kubelet.erb"),
      mode    => '644',
      require => Package['kubernetes'],
  } -> 

  file {'kube_config.yaml':
      path    => '/etc/kubernetes/kube_config.yaml',
      ensure  => 'present',
      content => template("$module_name/kube_config.yaml.erb"),
      mode    => '644',
  } ->

# Create /etc/kubernetes/manifests dir
  file { '/etc/kubernetes/manifests':
      ensure  => 'directory',
      mode    => '755',
  } ->

# Starting all master component containers 
  file {'kube_proxy.yaml':
      path    => '/etc/kubernetes/manifests/kube_proxy.yaml',
      ensure  => 'present',
      content => template("$module_name/kube_proxy.yaml.erb"),
      mode    => '644',
  } ->

  file {'kube_apiserver.yaml':
      path    => '/etc/kubernetes/manifests/kube_apiserver.yaml',
      ensure  => 'present',
      content => template("$module_name/kube_apiserver.yaml.erb"),
      mode    => '644',
  } ->

  file {'kube_controller_manager.yaml':
      path    => '/etc/kubernetes/manifests/kube_controller_manager.yaml',
      ensure  => 'present',
      content => template("$module_name/kube_controller_manager.yaml.erb"),
      mode    => '644',
  } ->

  file {'kube_scheduler.yaml':
      path    => '/etc/kubernetes/manifests/kube_scheduler.yaml',
      ensure  => 'present',
      content => template("$module_name/kube_scheduler.yaml.erb"),
      mode    => '644',
  } -> 

# Wait for all containers to come up

# Starting kubelet service
  service {'kubelet':
      name    => 'kubelet',
      ensure  => 'running',
      enable  => 'true',
  }
}
