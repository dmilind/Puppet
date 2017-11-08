# Puppet module to install and configure kubernetes (master on kubernetes hosts and agents on dockerhosts)
class kubernetes_master-1_0_0 {
# Installing required packages for kubernetes
    include kubernetes_master-1_0_0::package

# Providing certs 
    include kubernetes_master-1_0_0::cert

# Configuring local config for kubernetes in master nodes
    include kubernetes_master-1_0_0::local_config

# Configuring HA mode in master nodes
    include kubernetes_master-1_0_0::ha_config
}
