# Puppet module to install and configure kubernetes (master on kubernetes hosts and agents on dockerhosts)
class kubernetes_pupa {
# Installing required packages for kubernetes
    include kubernetes_pupa::package

# Configuring certs 
    include kubernetes_pupa::cert

# Configuring kubernetes master node
    include kubernetes_pupa::local_config

# Configuring HA mode in cluster
    include kubernetes_pupa::ha_config
}
