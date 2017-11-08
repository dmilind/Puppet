# Puppet module to install and configure kubernetes  agent on dockerhosts
class kubernetes_agent-1_0_0 {
# Installing required packages for kubernetes
    include kubernetes_agent-1_0_0::package

# Configuring certs 
    include kubernetes_agent-1_0_0::cert

# Configuring kubernetes master node
    include kubernetes_agent-1_0_0::kube_config

}
