from kubernetes import client, config
import os


# Load the Kubernetes configuration from the default location
#config.load_kube_config("~/.kube/config")
# Load the in-cluster configuration
config.load_incluster_config()
v1 = client.CoreV1Api()

namespace = "kafka"

# Iterate through the pods to fetch the secret name linked with each pod that is using it.
pod_list = v1.list_namespaced_pod(namespace)

secret_to_pod_mapping = {}
for pod in pod_list.items:
    for container in pod.spec.containers:
         if container.env:
          for env_var in container.env:
              if env_var.value_from and env_var.value_from.secret_key_ref:
                 secret_name = env_var.value_from.secret_key_ref.name
                 if secret_name in secret_to_pod_mapping:
                    # Each pod uses the same secret for different configuration. To remove duplicates pod 
                    # check if the pod already exist in the secret_to_pod_mapping[secret_name] list
                    if pod.metadata.name not in secret_to_pod_mapping[secret_name]:
                      secret_to_pod_mapping[secret_name].append(pod.metadata.name)
                 else:
                      secret_to_pod_mapping[secret_name] = [pod.metadata.name]
       
                

# Iterate through secrets and fetch its secret value. If the secret name is found in the secret_to_pod_mapping,
# the respective value is stored on a newly created dictionary named secret_with_no_owner
secrets = v1.list_namespaced_secret(namespace)

secret_with_no_owner = {}

secret_with_owner= {}

for secret in secrets.items:
   
   secret_name = secret.metadata.name
   if secret.metadata.owner_references is None and secret_name in secret_to_pod_mapping:
      if secret_name not in secret_with_no_owner:
         secret_with_no_owner[secret_name] = [secret.data]
      else:
         secret_with_no_owner[secret_name].append[secret.data]
   elif secret.metadata.owner_references is not None:# and secret_name in secret_to_pod_mapping:
        for ref in secret.metadata.owner_references:
           owner_name = ref.name
           if owner_name in secret_with_owner:
              secret_with_owner[secret_name].append(secret.data)
           secret_with_owner[secret_name] = [secret.data]
print(secret_with_no_owner)
          

#from cert_fetcher1 import *

#secretName_to_pod_mapping = get_secret_pod_mapping(pod_list)

#secretName_to_pod_mapping == secret_to_pod_mapping

#secret_with_no = get_secret_to_secretValue(secrets,secretName_to_pod_mapping)


# Organize secrets based on the component they belong to.

base_dir= 'mycertificates'




for component_name,cert_list in secret_with_no_owner.items():
    component_dir = os.path.join(base_dir,component_name)

    if not os.path.exists(component_dir):
       os.makedirs(component_dir)
       for key,val in cert_list[0].items():
          filepath = os.path.join(component_dir,key)

          with open(filepath,'w') as f:
             f.write(val)



import time
time.sleep(10000)
